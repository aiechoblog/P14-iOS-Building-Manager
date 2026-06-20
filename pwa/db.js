const P14_STORAGE_KEY = "p14_pwa_data_v1";

const P14_MONTHS = [
  "فروردین ۱۴۰۵",
  "اردیبهشت ۱۴۰۵",
  "خرداد ۱۴۰۵",
  "تیر ۱۴۰۵",
  "مرداد ۱۴۰۵",
  "شهریور ۱۴۰۵",
  "مهر ۱۴۰۵",
  "آبان ۱۴۰۵",
  "آذر ۱۴۰۵",
  "دی ۱۴۰۵",
  "بهمن ۱۴۰۵",
  "اسفند ۱۴۰۵"
];

const P14_BILL_TYPES = ["برق", "آب", "گاز", "تلفن", "اینترنت", "آسانسور", "عوارض", "سایر"];

function p14Id() {
  if (window.crypto && window.crypto.randomUUID) {
    return window.crypto.randomUUID();
  }
  return "id-" + Date.now() + "-" + Math.random().toString(16).slice(2);
}

function toPersianDigits(value) {
  return String(value)
    .replaceAll("0", "۰")
    .replaceAll("1", "۱")
    .replaceAll("2", "۲")
    .replaceAll("3", "۳")
    .replaceAll("4", "۴")
    .replaceAll("5", "۵")
    .replaceAll("6", "۶")
    .replaceAll("7", "۷")
    .replaceAll("8", "۸")
    .replaceAll("9", "۹");
}

function toEnglishDigits(value) {
  return String(value)
    .replaceAll("۰", "0")
    .replaceAll("۱", "1")
    .replaceAll("۲", "2")
    .replaceAll("۳", "3")
    .replaceAll("۴", "4")
    .replaceAll("۵", "5")
    .replaceAll("۶", "6")
    .replaceAll("۷", "7")
    .replaceAll("۸", "8")
    .replaceAll("۹", "9")
    .replaceAll("−", "-");
}

function normalizeNumberText(value) {
  return toEnglishDigits(value).replaceAll(",", "").replaceAll(" ", "").trim();
}

function parseAmount(value) {
  const normalized = normalizeNumberText(value);
  if (normalized === "" || normalized === "-") return NaN;
  return Number.parseInt(normalized, 10);
}

function isNumericText(value) {
  const normalized = normalizeNumberText(value);
  if (normalized === "" || normalized === "-") return false;
  return Number.isInteger(Number.parseInt(normalized, 10)) && String(Number.parseInt(normalized, 10)) === normalized;
}

function formatMoney(value) {
  const numberValue = Number.isFinite(value) ? value : 0;
  return toPersianDigits(numberValue.toLocaleString("en-US")) + " تومان";
}

function defaultBuildingInfo() {
  return {
    buildingName: "پلاک ۱۴",
    address: "",
    numberOfUnits: 9,
    defaultMonthlyCharge: 1200000,
    managerName: "",
    managerPhone: "",
    notes: "",
    accountingYearLabel: "۱۴۰۵",
    openingFundBalance: 0,
    openingBalanceDate: "۱۴۰۵/۰۱/۰۱",
    openingBalanceNotes: ""
  };
}

function createDefaultUnit(unitNumber, defaultCharge) {
  const name = "مالک واحد " + toPersianDigits(unitNumber);
  return {
    id: p14Id(),
    unitNumber,
    floor: "",
    area: "",
    ownerName: name,
    ownerPhone: "",
    isRented: false,
    tenantName: "",
    tenantPhone: "",
    tenantEntryDate: "",
    residentName: name,
    residentPhone: "",
    monthlyCharge: defaultCharge,
    notes: ""
  };
}

function defaultData() {
  const buildingInfo = defaultBuildingInfo();
  const units = [
    { id: p14Id(), unitNumber: 1, floor: "۱", area: "۹۰", ownerName: "احمدی", ownerPhone: "09120000001", isRented: false, tenantName: "", tenantPhone: "", tenantEntryDate: "", residentName: "احمدی", residentPhone: "09120000001", monthlyCharge: 1200000, notes: "" },
    { id: p14Id(), unitNumber: 2, floor: "۱", area: "۹۰", ownerName: "محمدی", ownerPhone: "09120000002", isRented: false, tenantName: "", tenantPhone: "", tenantEntryDate: "", residentName: "محمدی", residentPhone: "09120000002", monthlyCharge: 1200000, notes: "" },
    { id: p14Id(), unitNumber: 3, floor: "۲", area: "۹۵", ownerName: "رضایی", ownerPhone: "09120000003", isRented: false, tenantName: "", tenantPhone: "", tenantEntryDate: "", residentName: "رضایی", residentPhone: "09120000003", monthlyCharge: 1200000, notes: "پرداخت ناقص در نمونه" },
    { id: p14Id(), unitNumber: 4, floor: "۲", area: "۹۵", ownerName: "کاظمی", ownerPhone: "09120000004", isRented: false, tenantName: "", tenantPhone: "", tenantEntryDate: "", residentName: "کاظمی", residentPhone: "09120000004", monthlyCharge: 1200000, notes: "" },
    { id: p14Id(), unitNumber: 5, floor: "۳", area: "۱۰۰", ownerName: "حسینی", ownerPhone: "09120000005", isRented: false, tenantName: "", tenantPhone: "", tenantEntryDate: "", residentName: "حسینی", residentPhone: "09120000005", monthlyCharge: 1200000, notes: "" },
    { id: p14Id(), unitNumber: 6, floor: "۳", area: "۱۰۰", ownerName: "کریمی", ownerPhone: "09120000006", isRented: false, tenantName: "", tenantPhone: "", tenantEntryDate: "", residentName: "کریمی", residentPhone: "09120000006", monthlyCharge: 1200000, notes: "بدهکار در نمونه" },
    { id: p14Id(), unitNumber: 7, floor: "۴", area: "۱۰۵", ownerName: "موسوی", ownerPhone: "09120000007", isRented: false, tenantName: "", tenantPhone: "", tenantEntryDate: "", residentName: "موسوی", residentPhone: "09120000007", monthlyCharge: 1200000, notes: "" },
    { id: p14Id(), unitNumber: 8, floor: "۴", area: "۱۰۵", ownerName: "جعفری", ownerPhone: "09120000008", isRented: false, tenantName: "", tenantPhone: "", tenantEntryDate: "", residentName: "جعفری", residentPhone: "09120000008", monthlyCharge: 1200000, notes: "بدهکار در نمونه" },
    { id: p14Id(), unitNumber: 9, floor: "۵", area: "۱۱۰", ownerName: "مرادی", ownerPhone: "09120000009", isRented: false, tenantName: "", tenantPhone: "", tenantEntryDate: "", residentName: "مرادی", residentPhone: "09120000009", monthlyCharge: 1200000, notes: "بدهکار در نمونه" }
  ];

  return {
    buildingInfo,
    units,
    payments: [
      { id: p14Id(), unitNumber: 1, monthLabel: "خرداد ۱۴۰۵", paymentDate: "۱۴۰۵/۰۳/۰۵", amount: 1200000, notes: "پرداخت کامل" },
      { id: p14Id(), unitNumber: 2, monthLabel: "خرداد ۱۴۰۵", paymentDate: "۱۴۰۵/۰۳/۰۶", amount: 1200000, notes: "پرداخت کامل" },
      { id: p14Id(), unitNumber: 3, monthLabel: "خرداد ۱۴۰۵", paymentDate: "۱۴۰۵/۰۳/۰۷", amount: 600000, notes: "پرداخت نصف شارژ" },
      { id: p14Id(), unitNumber: 4, monthLabel: "خرداد ۱۴۰۵", paymentDate: "۱۴۰۵/۰۳/۰۸", amount: 1200000, notes: "پرداخت کامل" },
      { id: p14Id(), unitNumber: 5, monthLabel: "خرداد ۱۴۰۵", paymentDate: "۱۴۰۵/۰۳/۰۹", amount: 1200000, notes: "پرداخت کامل" },
      { id: p14Id(), unitNumber: 7, monthLabel: "خرداد ۱۴۰۵", paymentDate: "۱۴۰۵/۰۳/۱۰", amount: 1200000, notes: "پرداخت کامل" }
    ],
    expenses: [
      { id: p14Id(), monthLabel: "خرداد ۱۴۰۵", dateText: "۱۴۰۵/۰۳/۰۳", category: "نظافت", description: "حقوق نظافتچی", amount: 1500000, notes: "" }
    ],
    billProfiles: [
      { id: p14Id(), billType: "برق", title: "برق مشاعات", providerName: "شرکت برق", meterNumber: "", subscriptionNumber: "", billId: "", paymentId: "", defaultCategory: "قبض", notes: "", isActive: true },
      { id: p14Id(), billType: "آب", title: "آب ساختمان", providerName: "شرکت آب", meterNumber: "", subscriptionNumber: "", billId: "", paymentId: "", defaultCategory: "قبض", notes: "", isActive: true },
      { id: p14Id(), billType: "آسانسور", title: "سرویس آسانسور", providerName: "", meterNumber: "", subscriptionNumber: "", billId: "", paymentId: "", defaultCategory: "قبض", notes: "", isActive: true }
    ],
    billPayments: []
  };
}

function migrateUnit(unit, defaultCharge) {
  const ownerName = unit.ownerName || "";
  const oldPhone = unit.phoneNumber || "";
  const tenantName = unit.tenantName || "";
  const isRented = typeof unit.isRented === "boolean" ? unit.isRented : (tenantName !== "" && tenantName !== ownerName);
  const residentName = unit.residentName || (tenantName || ownerName);
  const residentPhone = unit.residentPhone || oldPhone || unit.ownerPhone || "";

  return {
    id: unit.id || p14Id(),
    unitNumber: Number(unit.unitNumber) || 1,
    floor: unit.floor || "",
    area: unit.area || "",
    ownerName,
    ownerPhone: unit.ownerPhone || oldPhone,
    isRented,
    tenantName,
    tenantPhone: unit.tenantPhone || "",
    tenantEntryDate: unit.tenantEntryDate || "",
    residentName,
    residentPhone,
    monthlyCharge: Number(unit.monthlyCharge) || defaultCharge,
    notes: unit.notes || ""
  };
}

function ensureUnits(data) {
  const count = Math.max(Number(data.buildingInfo.numberOfUnits) || 1, 1);
  data.buildingInfo.numberOfUnits = count;

  for (let number = 1; number <= count; number += 1) {
    const exists = data.units.some((unit) => Number(unit.unitNumber) === number);
    if (!exists) {
      data.units.push(createDefaultUnit(number, data.buildingInfo.defaultMonthlyCharge));
    }
  }

  data.units.sort((a, b) => Number(a.unitNumber) - Number(b.unitNumber));
  return data;
}

function migrateData(raw) {
  const fallback = defaultData();
  const data = raw && typeof raw === "object" ? raw : fallback;
  const oldBuilding = data.building || {};
  const buildingInfo = { ...defaultBuildingInfo(), ...oldBuilding, ...(data.buildingInfo || {}) };
  buildingInfo.numberOfUnits = Math.max(Number(buildingInfo.numberOfUnits) || 1, 1);
  buildingInfo.defaultMonthlyCharge = Number(buildingInfo.defaultMonthlyCharge) || 0;
  buildingInfo.openingFundBalance = Number(buildingInfo.openingFundBalance) || 0;

  const migrated = {
    buildingInfo,
    units: Array.isArray(data.units) ? data.units.map((unit) => migrateUnit(unit, buildingInfo.defaultMonthlyCharge)) : fallback.units,
    payments: Array.isArray(data.payments) ? data.payments : [],
    expenses: Array.isArray(data.expenses) ? data.expenses : [],
    billProfiles: Array.isArray(data.billProfiles) ? data.billProfiles : [],
    billPayments: Array.isArray(data.billPayments) ? data.billPayments : []
  };

  return ensureUnits(migrated);
}

function loadData() {
  const stored = localStorage.getItem(P14_STORAGE_KEY);
  if (!stored) {
    const data = defaultData();
    saveData(data);
    return data;
  }

  try {
    const data = migrateData(JSON.parse(stored));
    saveData(data);
    return data;
  } catch (error) {
    const data = defaultData();
    saveData(data);
    return data;
  }
}

function saveData(data) {
  localStorage.setItem(P14_STORAGE_KEY, JSON.stringify(data));
}

function resetData() {
  const data = defaultData();
  saveData(data);
  return data;
}

window.P14DB = {
  months: P14_MONTHS,
  billTypes: P14_BILL_TYPES,
  loadData,
  saveData,
  resetData,
  ensureUnits,
  p14Id,
  toPersianDigits,
  toEnglishDigits,
  parseAmount,
  isNumericText,
  formatMoney
};
