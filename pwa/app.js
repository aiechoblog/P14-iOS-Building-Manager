let appData = P14DB.loadData();
let currentView = "dashboard";
let editingUnitId = "";
let editingBillProfileId = "";

const appRoot = document.getElementById("app");
const titleEl = document.getElementById("app-title");
const monthSelect = document.getElementById("month-select");

function h(value) {
  return String(value ?? "")
    .replaceAll("&", "&amp;")
    .replaceAll("<", "&lt;")
    .replaceAll(">", "&gt;")
    .replaceAll('"', "&quot;")
    .replaceAll("'", "&#039;");
}

function saveAppData() {
  appData = P14DB.ensureUnits(appData);
  P14DB.saveData(appData);
}

function activeUnits() {
  const count = Number(appData.buildingInfo.numberOfUnits) || 1;
  return appData.units.filter((unit) => Number(unit.unitNumber) <= count);
}

function displayUnitName(unit) {
  if (unit.hasTenant && unit.tenantName) return unit.tenantName;
  return unit.ownerName || "";
}

function monthPayments(month) {
  return appData.payments.filter((payment) => payment.monthLabel === month);
}

function monthExpenses(month) {
  return appData.expenses.filter((expense) => expense.monthLabel === month);
}

function monthBillPayments(month) {
  return appData.billPayments.filter((bill) => bill.monthLabel === month);
}

function paidAmount(unitNumber, month) {
  return appData.payments
    .filter((payment) => Number(payment.unitNumber) === Number(unitNumber) && payment.monthLabel === month)
    .reduce((total, payment) => total + Number(payment.amount || 0), 0);
}

function expectedCharge() {
  return activeUnits().reduce((total, unit) => total + Number(unit.monthlyCharge || 0), 0);
}

function receivedPayments(month) {
  return monthPayments(month).reduce((total, payment) => total + Number(payment.amount || 0), 0);
}

function normalExpenses(month) {
  return monthExpenses(month).reduce((total, expense) => total + Number(expense.amount || 0), 0);
}

function utilityBills(month) {
  return monthBillPayments(month).reduce((total, bill) => total + Number(bill.amount || 0), 0);
}

function totalExpenses(month) {
  return normalExpenses(month) + utilityBills(month);
}

function allPaymentsTotal() {
  return appData.payments.reduce((total, payment) => total + Number(payment.amount || 0), 0);
}

function allNormalExpensesTotal() {
  return appData.expenses.reduce((total, expense) => total + Number(expense.amount || 0), 0);
}

function allBillPaymentsTotal() {
  return appData.billPayments.reduce((total, bill) => total + Number(bill.amount || 0), 0);
}

function currentFundBalance() {
  return Number(appData.buildingInfo.openingFundBalance || 0) + allPaymentsTotal() - allNormalExpensesTotal() - allBillPaymentsTotal();
}

function debtorRows(month) {
  return activeUnits()
    .map((unit) => {
      const paid = paidAmount(unit.unitNumber, month);
      const debt = Math.max(Number(unit.monthlyCharge || 0) - paid, 0);
      return { unit, paid, debt };
    })
    .filter((row) => row.debt > 0)
    .sort((a, b) => Number(a.unit.unitNumber) - Number(b.unit.unitNumber));
}

function billProfileTitle(id) {
  const profile = appData.billProfiles.find((item) => item.id === id);
  return profile ? profile.title : "قبض";
}

function monthOptions(selected) {
  return P14DB.months.map((month) => `<option value="${h(month)}" ${month === selected ? "selected" : ""}>${h(month)}</option>`).join("");
}

function billTypeOptions(selected) {
  return P14DB.billTypes.map((type) => `<option value="${h(type)}" ${type === selected ? "selected" : ""}>${h(type)}</option>`).join("");
}

function formattedInputValue(value, allowNegative = false) {
  return P14DB.formatInputNumber(String(value ?? ""), allowNegative);
}

function setView(view, params = {}) {
  currentView = view;
  editingUnitId = params.unitId || "";
  editingBillProfileId = params.profileId || "";
  render();
}

function renderMonthSelect() {
  monthSelect.innerHTML = monthOptions(appData.selectedMonth || "خرداد ۱۴۰۵");
  monthSelect.value = appData.selectedMonth || "خرداد ۱۴۰۵";
}

function syncChrome() {
  titleEl.textContent = appData.buildingInfo.buildingName || "مدیریت ساختمان";
  document.querySelectorAll(".bottom-nav button").forEach((button) => {
    button.classList.toggle("active", button.dataset.view === currentView);
  });
}

function render() {
  renderMonthSelect();
  syncChrome();

  if (currentView === "dashboard") renderDashboard();
  if (currentView === "settings") renderSettings();
  if (currentView === "units") renderUnits();
  if (currentView === "unit-edit") renderUnitEdit();
  if (currentView === "payments") renderPayments();
  if (currentView === "expenses") renderExpenses();
  if (currentView === "bills") renderBills();
  if (currentView === "bill-edit") renderBillProfileEdit();
  if (currentView === "bill-payment") renderBillPayment();
  if (currentView === "debtors") renderDebtors();
  if (currentView === "report") renderReport();

  appRoot.focus();
}

function card(title, value) {
  return `<section class="card"><p class="label">${h(title)}</p><p class="value">${h(value)}</p></section>`;
}

function field(label, name, value = "", type = "text", extra = "") {
  return `
    <div class="field">
      <label for="${h(name)}">${h(label)}</label>
      <input id="${h(name)}" name="${h(name)}" type="${h(type)}" value="${h(value)}" ${extra}>
    </div>
  `;
}

function moneyField(label, name, value = "", allowNegative = false) {
  const formatted = formattedInputValue(value, allowNegative);
  const negativeAttr = allowNegative ? 'data-allow-negative="true"' : "";
  return field(label, name, formatted, "text", `inputmode="numeric" data-money="true" ${negativeAttr}`);
}

function renderDashboard() {
  const month = appData.selectedMonth;
  appRoot.innerHTML = `
    <section class="grid cards">
      ${card("تعداد واحدها", P14DB.toPersianDigits(appData.buildingInfo.numberOfUnits))}
      ${card("شارژ مورد انتظار", P14DB.formatMoney(expectedCharge()))}
      ${card("موجودی اول دوره", P14DB.formatMoney(Number(appData.buildingInfo.openingFundBalance || 0)))}
      ${card("دریافتی ها", P14DB.formatMoney(receivedPayments(month)))}
      ${card("هزینه های عادی", P14DB.formatMoney(normalExpenses(month)))}
      ${card("قبض ها", P14DB.formatMoney(utilityBills(month)))}
      ${card("جمع هزینه ها", P14DB.formatMoney(totalExpenses(month)))}
      ${card("موجودی فعلی صندوق", P14DB.formatMoney(currentFundBalance()))}
      ${card("تعداد واحد بدهکار", P14DB.toPersianDigits(debtorRows(month).length))}
    </section>
    <section class="panel">
      <h2>آخرین پرداخت ها</h2>
      <div class="list">
        ${monthPayments(month).slice(-5).reverse().map((payment) => `
          <div class="list-item">
            <strong>واحد ${P14DB.toPersianDigits(payment.unitNumber)}</strong>
            <span>${h(payment.paymentDate)} - ${P14DB.formatMoney(payment.amount)}</span>
            <span class="muted">${h(payment.notes)}</span>
          </div>
        `).join("") || `<p class="muted">پرداختی برای این ماه ثبت نشده است.</p>`}
      </div>
    </section>
  `;
}

function renderSettings() {
  const b = appData.buildingInfo;
  appRoot.innerHTML = `
    <section class="panel">
      <h2>اطلاعات ساختمان</h2>
      <form id="settings-form" class="form-grid">
        ${field("نام ساختمان", "buildingName", b.buildingName)}
        ${field("آدرس", "address", b.address)}
        ${field("تعداد واحدها", "numberOfUnits", P14DB.toPersianDigits(b.numberOfUnits), "text", 'inputmode="numeric"')}
        ${moneyField("شارژ پیش فرض ماهانه", "defaultMonthlyCharge", b.defaultMonthlyCharge)}
        ${field("نام مدیر ساختمان", "managerName", b.managerName)}
        ${field("تلفن مدیر ساختمان", "managerPhone", b.managerPhone)}
        ${field("سال مالی", "accountingYearLabel", b.accountingYearLabel)}
        ${moneyField("موجودی اول دوره", "openingFundBalance", b.openingFundBalance, true)}
        ${field("تاریخ موجودی اول دوره", "openingBalanceDate", b.openingBalanceDate)}
        ${field("توضیحات موجودی اول دوره", "openingBalanceNotes", b.openingBalanceNotes)}
        <div class="field full">
          <label for="notes">توضیحات کلی</label>
          <textarea id="notes" name="notes">${h(b.notes)}</textarea>
        </div>
        <div class="actions full">
          <button class="btn" type="submit">ذخیره اطلاعات ساختمان</button>
          <button class="btn-secondary" type="button" data-action="reset-data">بازنشانی نمونه</button>
        </div>
        <p id="settings-message" class="muted full"></p>
      </form>
    </section>
  `;
  document.getElementById("settings-form").addEventListener("submit", saveSettings);
}

function saveSettings(event) {
  event.preventDefault();
  const form = new FormData(event.currentTarget);
  const unitCountText = form.get("numberOfUnits");
  const defaultChargeText = form.get("defaultMonthlyCharge");
  const openingText = form.get("openingFundBalance");
  const msg = document.getElementById("settings-message");

  if (!P14DB.isNumericText(unitCountText) || P14DB.parseAmount(unitCountText) < 1) {
    msg.textContent = "تعداد واحدها باید عدد و حداقل ۱ باشد.";
    msg.className = "danger full";
    return;
  }
  if (!P14DB.isNumericText(defaultChargeText) || P14DB.parseAmount(defaultChargeText) < 0) {
    msg.textContent = "شارژ پیش فرض باید عدد مثبت یا صفر باشد.";
    msg.className = "danger full";
    return;
  }
  if (!P14DB.isNumericText(openingText)) {
    msg.textContent = "موجودی اول دوره باید عدد باشد.";
    msg.className = "danger full";
    return;
  }

  appData.buildingInfo = {
    buildingName: String(form.get("buildingName") || "پلاک ۱۴"),
    address: String(form.get("address") || ""),
    numberOfUnits: P14DB.parseAmount(unitCountText),
    defaultMonthlyCharge: P14DB.parseAmount(defaultChargeText),
    managerName: String(form.get("managerName") || ""),
    managerPhone: String(form.get("managerPhone") || ""),
    notes: String(form.get("notes") || ""),
    accountingYearLabel: String(form.get("accountingYearLabel") || "۱۴۰۵"),
    openingFundBalance: P14DB.parseAmount(openingText),
    openingBalanceDate: String(form.get("openingBalanceDate") || "۱۴۰۵/۰۱/۰۱"),
    openingBalanceNotes: String(form.get("openingBalanceNotes") || "")
  };
  saveAppData();
  render();
}

function renderUnits() {
  appRoot.innerHTML = `
    <section class="panel">
      <h2>واحدها</h2>
      <p class="muted">برای ویرایش، روی واحد بزنید. اطلاعات ساکن جداگانه حذف شده و وضعیت مستاجر از همین فرم واحد مدیریت می شود.</p>
      <div class="list">
        ${activeUnits().map((unit) => `
          <button class="list-item" data-action="edit-unit" data-id="${h(unit.id)}">
            <strong>واحد ${P14DB.toPersianDigits(unit.unitNumber)} - ${h(displayUnitName(unit))}</strong>
            <span>مالک: ${h(unit.ownerName)} | شارژ: ${P14DB.formatMoney(unit.monthlyCharge)}</span>
            <span class="muted">${unit.hasTenant ? "دارای مستاجر" : "بدون مستاجر"} ${unit.moveInDate ? "- تاریخ ورود: " + h(unit.moveInDate) : ""}</span>
          </button>
        `).join("")}
      </div>
    </section>
  `;
}

function renderUnitEdit() {
  const unit = appData.units.find((item) => item.id === editingUnitId);
  if (!unit) {
    setView("units");
    return;
  }

  appRoot.innerHTML = `
    <section class="panel">
      <h2>ویرایش واحد</h2>
      <form id="unit-form" class="form-grid">
        ${field("شماره واحد", "unitNumber", P14DB.toPersianDigits(unit.unitNumber), "text", 'inputmode="numeric"')}
        ${field("نام مالک", "ownerName", unit.ownerName)}
        ${field("تلفن مالک", "ownerPhone", unit.ownerPhone, "tel")}
        <div class="field check-row full">
          <input id="hasTenant" name="hasTenant" type="checkbox" ${unit.hasTenant ? "checked" : ""}>
          <label for="hasTenant">مستاجر دارد؟</label>
        </div>
        <div id="tenant-fields" class="form-grid full ${unit.hasTenant ? "" : "hidden"}">
          ${field("نام مستاجر", "tenantName", unit.tenantName)}
          ${field("تلفن مستاجر", "tenantPhone", unit.tenantPhone, "tel")}
        </div>
        ${field("تاریخ ورود", "moveInDate", unit.moveInDate)}
        ${moneyField("شارژ ماهانه", "monthlyCharge", unit.monthlyCharge)}
        <div class="field full">
          <label for="notes">توضیحات</label>
          <textarea id="notes" name="notes">${h(unit.notes)}</textarea>
        </div>
        <div class="actions full">
          <button class="btn" type="submit">ذخیره</button>
          <button class="btn-secondary" type="button" data-view="units">انصراف</button>
        </div>
        <p id="unit-message" class="muted full"></p>
      </form>
    </section>
  `;

  document.getElementById("hasTenant").addEventListener("change", (event) => {
    document.getElementById("tenant-fields").classList.toggle("hidden", !event.target.checked);
  });
  document.getElementById("unit-form").addEventListener("submit", saveUnit);
}

function saveUnit(event) {
  event.preventDefault();
  const form = new FormData(event.currentTarget);
  const unit = appData.units.find((item) => item.id === editingUnitId);
  const unitNumberText = form.get("unitNumber");
  const chargeText = form.get("monthlyCharge");
  const hasTenant = form.get("hasTenant") === "on";
  const msg = document.getElementById("unit-message");

  if (!P14DB.isNumericText(unitNumberText) || P14DB.parseAmount(unitNumberText) < 1) {
    msg.textContent = "شماره واحد باید عدد و بزرگتر از صفر باشد.";
    msg.className = "danger full";
    return;
  }
  if (!P14DB.isNumericText(chargeText) || P14DB.parseAmount(chargeText) < 0) {
    msg.textContent = "شارژ ماهانه باید عدد مثبت یا صفر باشد.";
    msg.className = "danger full";
    return;
  }
  if (hasTenant && (!form.get("tenantName") || !form.get("tenantPhone"))) {
    msg.textContent = "برای واحد دارای مستاجر، نام و تلفن مستاجر را وارد کنید.";
    msg.className = "danger full";
    return;
  }

  unit.unitNumber = P14DB.parseAmount(unitNumberText);
  unit.ownerName = String(form.get("ownerName") || "");
  unit.ownerPhone = String(form.get("ownerPhone") || "");
  unit.hasTenant = hasTenant;
  unit.tenantName = hasTenant ? String(form.get("tenantName") || "") : "";
  unit.tenantPhone = hasTenant ? String(form.get("tenantPhone") || "") : "";
  unit.moveInDate = String(form.get("moveInDate") || "");
  unit.monthlyCharge = P14DB.parseAmount(chargeText);
  unit.notes = String(form.get("notes") || "");
  delete unit.residentName;
  delete unit.residentPhone;
  delete unit.tenantEntryDate;
  delete unit.isRented;
  saveAppData();
  setView("units");
}

function renderPayments() {
  const month = appData.selectedMonth;
  appRoot.innerHTML = `
    <section class="panel">
      <h2>ثبت پرداخت شارژ</h2>
      <form id="payment-form" class="form-grid">
        <div class="field">
          <label for="unitNumber">واحد</label>
          <select id="unitNumber" name="unitNumber">
            ${activeUnits().map((unit) => `<option value="${unit.unitNumber}">واحد ${P14DB.toPersianDigits(unit.unitNumber)} - ${h(displayUnitName(unit))}</option>`).join("")}
          </select>
        </div>
        <div class="field">
          <label for="monthLabel">ماه</label>
          <select id="monthLabel" name="monthLabel">${monthOptions(month)}</select>
        </div>
        ${field("تاریخ پرداخت", "paymentDate", "۱۴۰۵/۰۳/۰۱")}
        ${moneyField("مبلغ", "amount", "")}
        ${field("توضیحات", "notes", "شارژ ماهانه")}
        <div class="actions full"><button class="btn" type="submit">ثبت پرداخت</button></div>
        <p id="payment-message" class="muted full"></p>
      </form>
    </section>
  `;
  document.getElementById("payment-form").addEventListener("submit", savePayment);
}

function savePayment(event) {
  event.preventDefault();
  const form = new FormData(event.currentTarget);
  const amountText = form.get("amount");
  const msg = document.getElementById("payment-message");
  if (!P14DB.isNumericText(amountText) || P14DB.parseAmount(amountText) < 0) {
    msg.textContent = "مبلغ پرداخت باید عدد مثبت یا صفر باشد.";
    msg.className = "danger full";
    return;
  }
  appData.payments.push({
    id: P14DB.p14Id(),
    unitNumber: P14DB.parseAmount(form.get("unitNumber")),
    monthLabel: String(form.get("monthLabel")),
    paymentDate: String(form.get("paymentDate") || ""),
    amount: P14DB.parseAmount(amountText),
    notes: String(form.get("notes") || "")
  });
  saveAppData();
  msg.textContent = "پرداخت ثبت شد.";
  msg.className = "success full";
  event.currentTarget.reset();
}

function renderExpenses() {
  appRoot.innerHTML = `
    <section class="panel">
      <h2>ثبت هزینه عادی</h2>
      <form id="expense-form" class="form-grid">
        <div class="field"><label for="monthLabel">ماه</label><select id="monthLabel" name="monthLabel">${monthOptions(appData.selectedMonth)}</select></div>
        ${field("تاریخ", "dateText", "۱۴۰۵/۰۳/۰۱")}
        ${field("دسته بندی", "category", "نظافت")}
        ${field("شرح هزینه", "description", "")}
        ${moneyField("مبلغ", "amount", "")}
        ${field("توضیحات", "notes", "")}
        <div class="actions full"><button class="btn" type="submit">ثبت هزینه</button></div>
        <p id="expense-message" class="muted full"></p>
      </form>
    </section>
  `;
  document.getElementById("expense-form").addEventListener("submit", saveExpense);
}

function saveExpense(event) {
  event.preventDefault();
  const form = new FormData(event.currentTarget);
  const amountText = form.get("amount");
  const msg = document.getElementById("expense-message");
  if (!P14DB.isNumericText(amountText) || P14DB.parseAmount(amountText) < 0) {
    msg.textContent = "مبلغ هزینه باید عدد مثبت یا صفر باشد.";
    msg.className = "danger full";
    return;
  }
  appData.expenses.push({
    id: P14DB.p14Id(),
    monthLabel: String(form.get("monthLabel")),
    dateText: String(form.get("dateText") || ""),
    category: String(form.get("category") || ""),
    description: String(form.get("description") || ""),
    amount: P14DB.parseAmount(amountText),
    notes: String(form.get("notes") || "")
  });
  saveAppData();
  msg.textContent = "هزینه ثبت شد.";
  msg.className = "success full";
  event.currentTarget.reset();
}

function renderBills() {
  const profiles = appData.billProfiles;
  appRoot.innerHTML = `
    <section class="panel">
      <h2>قبض ها</h2>
      <div class="actions">
        <button class="btn" data-view="bill-payment">ثبت پرداخت قبض</button>
        <button class="btn-secondary" data-view="bill-edit">افزودن پروفایل قبض</button>
      </div>
    </section>
    <section class="panel">
      <h2>پروفایل قبض ها</h2>
      <div class="list">
        ${profiles.map((profile) => `
          <button class="list-item" data-action="edit-bill-profile" data-id="${h(profile.id)}">
            <strong>${h(profile.title)}</strong>
            <span>نوع: ${h(profile.billType)} | ${profile.isActive ? "فعال" : "غیرفعال"}</span>
            <span class="muted">${h(profile.providerName || "")}</span>
          </button>
        `).join("") || `<p class="muted">هنوز پروفایل قبض ثبت نشده است.</p>`}
      </div>
    </section>
  `;
}

function renderBillProfileEdit() {
  const profile = appData.billProfiles.find((item) => item.id === editingBillProfileId) || null;
  appRoot.innerHTML = `
    <section class="panel">
      <h2>${profile ? "ویرایش پروفایل قبض" : "پروفایل قبض جدید"}</h2>
      <form id="bill-profile-form" class="form-grid">
        <div class="field"><label for="billType">نوع قبض</label><select id="billType" name="billType">${billTypeOptions(profile?.billType || "برق")}</select></div>
        ${field("عنوان", "title", profile?.title || "")}
        ${field("ارائه دهنده", "providerName", profile?.providerName || "")}
        ${field("شماره کنتور", "meterNumber", profile?.meterNumber || "")}
        ${field("شماره اشتراک", "subscriptionNumber", profile?.subscriptionNumber || "")}
        ${field("شناسه قبض", "billId", profile?.billId || "")}
        ${field("شناسه پرداخت", "paymentId", profile?.paymentId || "")}
        ${field("دسته بندی پیش فرض", "defaultCategory", profile?.defaultCategory || "قبض")}
        <div class="field check-row full"><input id="isActive" name="isActive" type="checkbox" ${profile?.isActive === false ? "" : "checked"}><label for="isActive">فعال است؟</label></div>
        <div class="field full"><label for="notes">توضیحات</label><textarea id="notes" name="notes">${h(profile?.notes || "")}</textarea></div>
        <div class="actions full">
          <button class="btn" type="submit">ذخیره</button>
          <button class="btn-secondary" type="button" data-view="bills">انصراف</button>
        </div>
        <p id="bill-profile-message" class="muted full"></p>
      </form>
    </section>
  `;
  document.getElementById("bill-profile-form").addEventListener("submit", saveBillProfile);
}

function saveBillProfile(event) {
  event.preventDefault();
  const form = new FormData(event.currentTarget);
  const msg = document.getElementById("bill-profile-message");
  const title = String(form.get("title") || "").trim();
  const billType = String(form.get("billType") || "").trim();
  if (!title || !billType) {
    msg.textContent = "نوع قبض و عنوان الزامی است.";
    msg.className = "danger full";
    return;
  }
  const profile = appData.billProfiles.find((item) => item.id === editingBillProfileId);
  const next = {
    id: profile ? profile.id : P14DB.p14Id(),
    billType,
    title,
    providerName: String(form.get("providerName") || ""),
    meterNumber: String(form.get("meterNumber") || ""),
    subscriptionNumber: String(form.get("subscriptionNumber") || ""),
    billId: String(form.get("billId") || ""),
    paymentId: String(form.get("paymentId") || ""),
    defaultCategory: String(form.get("defaultCategory") || ""),
    notes: String(form.get("notes") || ""),
    isActive: form.get("isActive") === "on"
  };
  if (profile) Object.assign(profile, next);
  else appData.billProfiles.push(next);
  saveAppData();
  setView("bills");
}

function renderBillPayment() {
  const activeProfiles = appData.billProfiles.filter((profile) => profile.isActive);
  appRoot.innerHTML = `
    <section class="panel">
      <h2>ثبت پرداخت قبض</h2>
      ${activeProfiles.length === 0 ? `<p class="muted">ابتدا یک پروفایل قبض فعال بسازید.</p>` : `
        <form id="bill-payment-form" class="form-grid">
          <div class="field"><label for="billProfileId">قبض</label><select id="billProfileId" name="billProfileId">${activeProfiles.map((profile) => `<option value="${h(profile.id)}">${h(profile.title)}</option>`).join("")}</select></div>
          <div class="field"><label for="monthLabel">ماه</label><select id="monthLabel" name="monthLabel">${monthOptions(appData.selectedMonth)}</select></div>
          ${field("دوره قبض", "billPeriod", "")}
          ${field("تاریخ صدور", "issueDateText", "")}
          ${field("مهلت پرداخت", "dueDateText", "")}
          ${field("تاریخ پرداخت", "paymentDateText", "")}
          ${moneyField("مبلغ", "amount", "")}
          ${field("شماره پیگیری پرداخت", "paymentTrackingNumber", "")}
          ${field("توضیحات", "notes", "")}
          <div class="actions full">
            <button class="btn" type="submit">ثبت پرداخت قبض</button>
            <button class="btn-secondary" type="button" data-view="bills">بازگشت</button>
          </div>
          <p id="bill-payment-message" class="muted full"></p>
        </form>
      `}
    </section>
  `;
  const form = document.getElementById("bill-payment-form");
  if (form) form.addEventListener("submit", saveBillPayment);
}

function saveBillPayment(event) {
  event.preventDefault();
  const form = new FormData(event.currentTarget);
  const amountText = form.get("amount");
  const msg = document.getElementById("bill-payment-message");
  if (!P14DB.isNumericText(amountText) || P14DB.parseAmount(amountText) < 0) {
    msg.textContent = "مبلغ قبض باید عدد مثبت یا صفر باشد.";
    msg.className = "danger full";
    return;
  }
  appData.billPayments.push({
    id: P14DB.p14Id(),
    billProfileId: String(form.get("billProfileId")),
    monthLabel: String(form.get("monthLabel")),
    billPeriod: String(form.get("billPeriod") || ""),
    issueDateText: String(form.get("issueDateText") || ""),
    dueDateText: String(form.get("dueDateText") || ""),
    paymentDateText: String(form.get("paymentDateText") || ""),
    amount: P14DB.parseAmount(amountText),
    paymentTrackingNumber: String(form.get("paymentTrackingNumber") || ""),
    notes: String(form.get("notes") || "")
  });
  saveAppData();
  setView("bills");
}

function renderDebtors() {
  const rows = debtorRows(appData.selectedMonth);
  appRoot.innerHTML = `
    <section class="panel">
      <h2>بدهکاران ${h(appData.selectedMonth)}</h2>
      <div class="list">
        ${rows.map((row) => `
          <div class="list-item">
            <strong>واحد ${P14DB.toPersianDigits(row.unit.unitNumber)} - ${h(displayUnitName(row.unit))}</strong>
            <span>پرداخت شده: ${P14DB.formatMoney(row.paid)}</span>
            <span class="danger">بدهی: ${P14DB.formatMoney(row.debt)}</span>
          </div>
        `).join("") || `<p class="success">همه واحدها برای این ماه تسویه هستند.</p>`}
      </div>
    </section>
  `;
}

function reportText(month) {
  const rows = debtorRows(month);
  const bills = monthBillPayments(month);
  const lines = [];
  lines.push("گزارش ماهانه " + appData.buildingInfo.buildingName);
  lines.push("ماه: " + month);
  lines.push("--------------------");
  lines.push("");
  lines.push("خلاصه مالی");
  lines.push("تعداد واحدها: " + P14DB.toPersianDigits(appData.buildingInfo.numberOfUnits));
  lines.push("سال مالی: " + appData.buildingInfo.accountingYearLabel);
  lines.push("موجودی اول دوره: " + P14DB.formatMoney(appData.buildingInfo.openingFundBalance));
  lines.push("دریافتی شارژ: " + P14DB.formatMoney(receivedPayments(month)));
  lines.push("هزینه های عادی: " + P14DB.formatMoney(normalExpenses(month)));
  lines.push("قبض ها: " + P14DB.formatMoney(utilityBills(month)));
  lines.push("جمع کل هزینه ها: " + P14DB.formatMoney(totalExpenses(month)));
  lines.push("موجودی فعلی صندوق: " + P14DB.formatMoney(currentFundBalance()));
  lines.push("");
  lines.push("قبض های ماه:");
  if (bills.length === 0) lines.push("قبضی برای این ماه ثبت نشده است.");
  bills.forEach((bill) => lines.push(billProfileTitle(bill.billProfileId) + ": " + P14DB.formatMoney(bill.amount)));
  lines.push("");
  lines.push("بدهکاران:");
  if (rows.length === 0) lines.push("همه واحدها تسویه هستند.");
  rows.forEach((row) => lines.push("واحد " + P14DB.toPersianDigits(row.unit.unitNumber) + " - " + displayUnitName(row.unit) + ": " + P14DB.formatMoney(row.debt)));
  if (appData.buildingInfo.managerName || appData.buildingInfo.managerPhone) {
    lines.push("");
    lines.push("مدیر ساختمان: " + appData.buildingInfo.managerName + " " + P14DB.toPersianDigits(appData.buildingInfo.managerPhone));
  }
  lines.push("");
  lines.push("پیام کوتاه برای ساکنان:");
  lines.push(residentsMessage(month));
  return lines.join("\n");
}

function residentsMessage(month) {
  const rows = debtorRows(month);
  const lines = [];
  lines.push("سلام و احترام");
  lines.push("گزارش کوتاه شارژ " + appData.buildingInfo.buildingName + " برای " + month + ":");
  lines.push("");
  lines.push("دریافتی شارژ: " + P14DB.formatMoney(receivedPayments(month)));
  lines.push("جمع هزینه ها: " + P14DB.formatMoney(totalExpenses(month)));
  lines.push("موجودی فعلی صندوق: " + P14DB.formatMoney(currentFundBalance()));
  lines.push("");
  if (rows.length === 0) {
    lines.push("همه واحدها برای این ماه تسویه هستند.");
  } else {
    lines.push("واحدهای دارای بدهی:");
    rows.forEach((row) => lines.push("واحد " + P14DB.toPersianDigits(row.unit.unitNumber) + " - " + displayUnitName(row.unit) + ": " + P14DB.formatMoney(row.debt)));
  }
  lines.push("");
  lines.push("با تشکر از همراهی شما");
  return lines.join("\n");
}

function renderReport() {
  const text = reportText(appData.selectedMonth);
  appRoot.innerHTML = `
    <section class="panel">
      <h2>گزارش ماهانه</h2>
      <textarea id="report-text" class="report-box" readonly>${h(text)}</textarea>
      <div class="actions">
        <button class="btn" data-action="copy-report">کپی گزارش</button>
        <button class="btn-secondary" data-action="download-report">خروجی فایل متنی</button>
      </div>
      <p id="report-message" class="muted"></p>
    </section>
  `;
}

function downloadReport() {
  const text = reportText(appData.selectedMonth);
  const fileName = "monthly_report_" + appData.selectedMonth.replaceAll(" ", "_") + ".txt";
  const blob = new Blob([text], { type: "text/plain;charset=utf-8" });
  const url = URL.createObjectURL(blob);
  const link = document.createElement("a");
  link.href = url;
  link.download = fileName;
  document.body.appendChild(link);
  link.click();
  link.remove();
  URL.revokeObjectURL(url);
}

document.querySelector(".bottom-nav").addEventListener("click", (event) => {
  const button = event.target.closest("button[data-view]");
  if (button) setView(button.dataset.view);
});

monthSelect.addEventListener("change", () => {
  appData.selectedMonth = monthSelect.value;
  saveAppData();
  render();
});

appRoot.addEventListener("input", (event) => {
  const input = event.target.closest("input[data-money='true']");
  if (!input) return;
  const allowNegative = input.dataset.allowNegative === "true";
  input.value = P14DB.formatInputNumber(input.value, allowNegative);
});

appRoot.addEventListener("click", async (event) => {
  const viewButton = event.target.closest("[data-view]");
  if (viewButton) {
    setView(viewButton.dataset.view);
    return;
  }
  const actionButton = event.target.closest("[data-action]");
  if (!actionButton) return;

  const action = actionButton.dataset.action;
  if (action === "edit-unit") setView("unit-edit", { unitId: actionButton.dataset.id });
  if (action === "edit-bill-profile") setView("bill-edit", { profileId: actionButton.dataset.id });
  if (action === "download-report") downloadReport();
  if (action === "copy-report") {
    await navigator.clipboard.writeText(reportText(appData.selectedMonth));
    document.getElementById("report-message").textContent = "گزارش کپی شد.";
  }
  if (action === "reset-data") {
    if (confirm("همه داده های محلی حذف و داده نمونه ساخته شود؟")) {
      appData = P14DB.resetData();
      render();
    }
  }
});

render();
