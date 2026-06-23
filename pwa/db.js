const P14_STORAGE_KEY = "P14_APP_DATA_V1";
const P14_OLD_STORAGE_KEYS = ["p14_pwa_data_v1"];
const P14_APP_DATA_VERSION = 1;

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

const P14_ALLOCATION_METHODS = [
  { value: "equal", label: "مساوی بین واحدهای فعال" },
  { value: "area", label: "بر اساس متراژ" },
  { value: "people", label: "بر اساس تعداد نفرات" },
  { value: "manual", label: "دستی / سفارشی" }
];

let lastLoadWarning = "";

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
  return String(value ?? "")
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
  return toEnglishDigits(value)
    .replaceAll(",", "")
    .replaceAll("٬", "")
    .replaceAll("،", "")
    .replaceAll(" ", "")
    .trim();
}

function parseAmount(value) {
  if (typeof value === "number") return Number.isFinite(value) ? value : NaN;
  const normalized = normalizeNumberText(value);
  if (normalized === "" || normalized === "-") return NaN;
  return Number.parseInt(normalized, 10);
}

function parseSafeNumber(value, fallback = 0) {
  const parsed = parseAmount(value);
  return Number.isFinite(parsed) ? parsed : fallback;
}

function isNumericText(value) {
  const normalized = normalizeNumberText(value);
  if (normalized === "" || normalized === "-") return false;
  return /^-?\d+$/.test(normalized);
}

function formatInputNumber(value, allowNegative = false) {
  let normalized = normalizeNumberText(value);
  let isNegative = false;

  if (normalized.startsWith("-")) {
    isNegative = allowNegative;
    normalized = normalized.slice(1);
  }

  normalized = normalized.replace(/\D/g, "");
  if (normalized === "") return isNegative ? "-" : "";

  const withCommas = Number.parseInt(normalized, 10).toLocaleString("en-US");
  return (isNegative ? "-" : "") + withCommas;
}

function formatMoney(value) {
  const numberValue = Number.isFinite(Number(value)) ? Number(value) : 0;
  return toPersianDigits(numberValue.toLocaleString("en-US")) + " تومان";
}

function allocationLabel(value) {
  const found = P14_ALLOCATION_METHODS.find((method) => method.value === value);
  return found ? found.label : P14_ALLOCATION_METHODS[0].label;
}

function defaultAllocationForBillType(billType) {
  if (billType === "آب") return "people";
  if (billType === "گاز") return "area";
  if (billType === "نظافت" || billType === "آسانسور") return "equal";
  return "equal";
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
    chargeCalculationMethod: "fixed",
    accountingYearLabel: "۱۴۰۵",
    openingFundBalance: 0,
    openingBalanceDate: "۱۴۰۵/۰۱/۰۱",
    openingBalanceNotes: ""
  };
}

function createDefaultUnit(unitNumber, defaultCharge) {
  return {
    id: p14Id(),
    unitNumber,
    floor: "",
    area: 0,
    ownerName: "",
    ownerPhone: "",
    hasTenant: false,
    tenantName: "",
    tenantPhone: "",
    tenantMoveInDate: "",
    peopleCount: 1,
    isActive: true,
    monthlyCharge: defaultCharge,
    notes: ""
  };
}

function emptyData() {
  const buildingInfo = defaultBuildingInfo();
  const data = {
    appDataVersion: P14_APP_DATA_VERSION,
    buildingInfo,
    selectedMonth: "خرداد ۱۴۰۵",
    units: [],
    payments: [],
    expenses: [],
    billProfiles: [],
    billPayments: [],
    reports: []
  };
  return ensureUnits(data);
}

function normalizeBoolean(value, fallback = false) {
  if (typeof value === "boolean") return value;
  if (typeof value === "string") {
    const normalized = value.toLowerCase().trim();
    if (["true", "1", "yes", "y", "بله", "دارد", "فعال"].includes(normalized)) return true;
    if (["false", "0", "no", "n", "خیر", "ندارد", "غیرفعال"].includes(normalized)) return false;
  }
  if (typeof value === "number") return value !== 0;
  return fallback;
}

function migrateBuildingInfo(data) {
  const oldBuilding = data.building || {};
  const buildingInfo = { ...defaultBuildingInfo(), ...oldBuilding, ...(data.buildingInfo || {}) };
  buildingInfo.numberOfUnits = Math.max(parseSafeNumber(buildingInfo.numberOfUnits, 1), 1);
  buildingInfo.defaultMonthlyCharge = Math.max(parseSafeNumber(buildingInfo.defaultMonthlyCharge, 0), 0);
  buildingInfo.openingFundBalance = parseSafeNumber(buildingInfo.openingFundBalance, 0);
  return buildingInfo;
}

function migrateUnit(unit, defaultCharge) {
  const oldTenantName = unit.tenantName || "";
  const oldTenantPhone = unit.tenantPhone || "";
  const inferredTenant = Boolean(oldTenantName || oldTenantPhone || unit.tenantMoveInDate || unit.moveInDate || unit.tenantEntryDate);
  const hasTenant = typeof unit.hasTenant === "boolean"
    ? unit.hasTenant
    : normalizeBoolean(unit.isRented, inferredTenant);

  const next = { ...unit };
  next.id = unit.id || p14Id();
  next.unitNumber = Math.max(parseSafeNumber(unit.unitNumber, 1), 1);
  next.floor = unit.floor || "";
  next.area = Math.max(parseSafeNumber(unit.area, 0), 0);
  next.ownerName = unit.ownerName || "";
  next.ownerPhone = unit.ownerPhone || unit.phoneNumber || "";
  next.hasTenant = hasTenant;
  next.tenantName = hasTenant ? oldTenantName : "";
  next.tenantPhone = hasTenant ? oldTenantPhone : "";
  next.tenantMoveInDate = unit.tenantMoveInDate || unit.moveInDate || unit.tenantEntryDate || "";
  next.peopleCount = Math.max(parseSafeNumber(unit.peopleCount, 1), 0);
  next.isActive = typeof unit.isActive === "boolean" ? unit.isActive : true;
  next.monthlyCharge = Math.max(parseSafeNumber(unit.monthlyCharge, defaultCharge || 0), 0);
  next.notes = unit.notes || "";
  return next;
}

function migratePayment(payment) {
  const next = { ...payment };
  next.id = payment.id || p14Id();
  next.unitNumber = parseSafeNumber(payment.unitNumber, 1);
  next.monthLabel = payment.monthLabel || "خرداد ۱۴۰۵";
  next.paymentDate = payment.paymentDate || payment.paymentDateText || "";
  next.amount = Math.max(parseSafeNumber(payment.amount, 0), 0);
  next.notes = payment.notes || "";
  return next;
}

function normalizeAllocationMethod(value) {
  const allowed = P14_ALLOCATION_METHODS.map((method) => method.value);
  return allowed.includes(value) ? value : "equal";
}

function migrateExpense(expense) {
  const next = { ...expense };
  next.id = expense.id || p14Id();
  next.monthLabel = expense.monthLabel || "خرداد ۱۴۰۵";
  next.dateText = expense.dateText || "";
  next.category = expense.category || "";
  next.description = expense.description || "";
  next.amount = Math.max(parseSafeNumber(expense.amount, 0), 0);
  next.allocationMethod = normalizeAllocationMethod(expense.allocationMethod || "equal");
  next.notes = expense.notes || "";
  return next;
}

function migrateBillProfile(profile) {
  const billType = profile.billType || "سایر";
  const next = { ...profile };
  next.id = profile.id || p14Id();
  next.billType = billType;
  next.title = profile.title || "";
  next.providerName = profile.providerName || "";
  next.meterNumber = profile.meterNumber || "";
  next.subscriptionNumber = profile.subscriptionNumber || "";
  next.billId = profile.billId || "";
  next.paymentId = profile.paymentId || "";
  next.defaultCategory = profile.defaultCategory || "قبض";
  next.defaultAllocationMethod = normalizeAllocationMethod(profile.defaultAllocationMethod || defaultAllocationForBillType(billType));
  next.notes = profile.notes || "";
  next.isActive = typeof profile.isActive === "boolean" ? profile.isActive : true;
  return next;
}

function migrateBillPayment(payment) {
  const next = { ...payment };
  next.id = payment.id || p14Id();
  next.billProfileId = payment.billProfileId || "";
  next.monthLabel = payment.monthLabel || "خرداد ۱۴۰۵";
  next.billPeriod = payment.billPeriod || "";
  next.issueDateText = payment.issueDateText || "";
  next.dueDateText = payment.dueDateText || "";
  next.paymentDateText = payment.paymentDateText || "";
  next.amount = Math.max(parseSafeNumber(payment.amount, 0), 0);
  next.allocationMethod = normalizeAllocationMethod(payment.allocationMethod || "equal");
  next.paymentTrackingNumber = payment.paymentTrackingNumber || "";
  next.notes = payment.notes || "";
  return next;
}

function ensureUnits(data) {
  if (!Array.isArray(data.units)) data.units = [];
  const count = Math.max(parseSafeNumber(data.buildingInfo.numberOfUnits, 1), 1);
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
  const source = raw && typeof raw === "object" ? raw : {};
  const buildingInfo = migrateBuildingInfo(source);

  const migrated = {
    ...source,
    appDataVersion: P14_APP_DATA_VERSION,
    buildingInfo,
    selectedMonth: source.selectedMonth || "خرداد ۱۴۰۵",
    units: Array.isArray(source.units) ? source.units.map((unit) => migrateUnit(unit, buildingInfo.defaultMonthlyCharge)) : [],
    payments: Array.isArray(source.payments) ? source.payments.map(migratePayment) : [],
    expenses: Array.isArray(source.expenses) ? source.expenses.map(migrateExpense) : [],
    billProfiles: Array.isArray(source.billProfiles) ? source.billProfiles.map(migrateBillProfile) : [],
    billPayments: Array.isArray(source.billPayments) ? source.billPayments.map(migrateBillPayment) : [],
    reports: Array.isArray(source.reports) ? source.reports : []
  };

  return ensureUnits(migrated);
}

function readStoredJson(key) {
  const text = localStorage.getItem(key);
  if (!text) return { exists: false, data: null, error: null };
  try {
    return { exists: true, data: JSON.parse(text), error: null };
  } catch (error) {
    return { exists: true, data: null, error };
  }
}

function preserveCorruptData(key) {
  const text = localStorage.getItem(key);
  if (!text) return;
  const backupKey = key + "_CORRUPT_BACKUP_" + new Date().toISOString();
  localStorage.setItem(backupKey, text);
}

function loadData() {
  lastLoadWarning = "";
  const current = readStoredJson(P14_STORAGE_KEY);

  if (current.exists && current.data) {
    const data = migrateData(current.data);
    saveData(data);
    return data;
  }

  if (current.exists && current.error) {
    preserveCorruptData(P14_STORAGE_KEY);
    lastLoadWarning = "داده ذخیره شده قابل خواندن نبود. یک نسخه پشتیبان از متن خراب نگه داشته شد.";
    return emptyData();
  }

  for (const oldKey of P14_OLD_STORAGE_KEYS) {
    const oldStored = readStoredJson(oldKey);
    if (oldStored.exists && oldStored.data) {
      const data = migrateData(oldStored.data);
      saveData(data);
      return data;
    }
    if (oldStored.exists && oldStored.error) {
      preserveCorruptData(oldKey);
      lastLoadWarning = "داده قدیمی قابل خواندن نبود. یک نسخه پشتیبان از متن خراب نگه داشته شد.";
    }
  }

  const data = emptyData();
  saveData(data);
  return data;
}

function saveData(data) {
  const migrated = migrateData(data);
  localStorage.setItem(P14_STORAGE_KEY, JSON.stringify(migrated));
}

function resetData() {
  const data = emptyData();
  saveData(data);
  return data;
}

function exportData(data) {
  return JSON.stringify(migrateData(data), null, 2);
}

function importData(raw) {
  if (!raw || typeof raw !== "object") {
    throw new Error("ساختار فایل پشتیبان معتبر نیست.");
  }
  const hasUsefulData = raw.buildingInfo || raw.building || Array.isArray(raw.units) || Array.isArray(raw.payments) || Array.isArray(raw.expenses) || Array.isArray(raw.billProfiles) || Array.isArray(raw.billPayments);
  if (!hasUsefulData) {
    throw new Error("این فایل شبیه فایل پشتیبان P14 نیست.");
  }
  const data = migrateData(raw);
  saveData(data);
  return data;
}

function getLastLoadWarning() {
  return lastLoadWarning;
}

window.P14DB = {
  storageKey: P14_STORAGE_KEY,
  appDataVersion: P14_APP_DATA_VERSION,
  months: P14_MONTHS,
  billTypes: P14_BILL_TYPES,
  allocationMethods: P14_ALLOCATION_METHODS,
  loadData,
  saveData,
  resetData,
  exportData,
  importData,
  ensureUnits,
  p14Id,
  toPersianDigits,
  toEnglishDigits,
  parseAmount,
  parseSafeNumber,
  isNumericText,
  formatInputNumber,
  formatMoney,
  allocationLabel,
  defaultAllocationForBillType,
  getLastLoadWarning
};
