export const APP_NAME = "À Table !";

export const DEFAULT_SERVINGS = 4;

export const PREP_TIME_FILTERS = [
  { label: "< 15 min", value: "0-15" },
  { label: "15-30 min", value: "15-30" },
  { label: "30-60 min", value: "30-60" },
  { label: "> 60 min", value: "60+" },
] as const;

export const COOK_TIME_FILTERS = [
  { label: "< 15 min", value: "0-15" },
  { label: "15-30 min", value: "15-30" },
  { label: "30-60 min", value: "30-60" },
  { label: "> 60 min", value: "60+" },
] as const;

export const ITEMS_PER_PAGE = 20;
