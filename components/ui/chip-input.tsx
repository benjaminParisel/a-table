"use client";

import { useState, type KeyboardEvent } from "react";
import { X } from "lucide-react";
import { Badge } from "@/components/ui/badge";
import { Input } from "@/components/ui/input";

interface ChipInputProps {
  value: string[];
  onChange: (values: string[]) => void;
  placeholder?: string;
  disabled?: boolean;
}

export function ChipInput({
  value,
  onChange,
  placeholder = "Ajouter...",
  disabled = false,
}: ChipInputProps) {
  const [inputValue, setInputValue] = useState("");

  const addChip = (chip: string) => {
    const trimmed = chip.trim().toLowerCase();
    if (trimmed && !value.includes(trimmed)) {
      onChange([...value, trimmed]);
    }
    setInputValue("");
  };

  const removeChip = (chipToRemove: string) => {
    onChange(value.filter((chip) => chip !== chipToRemove));
  };

  const handleKeyDown = (e: KeyboardEvent<HTMLInputElement>) => {
    if (e.key === "Enter" || e.key === ",") {
      e.preventDefault();
      addChip(inputValue);
    } else if (e.key === "Backspace" && !inputValue && value.length > 0) {
      removeChip(value[value.length - 1]);
    }
  };

  return (
    <div className="space-y-2">
      <Input
        value={inputValue}
        onChange={(e) => setInputValue(e.target.value)}
        onKeyDown={handleKeyDown}
        onBlur={() => inputValue && addChip(inputValue)}
        placeholder={placeholder}
        disabled={disabled}
      />
      {value.length > 0 && (
        <div className="flex flex-wrap gap-2">
          {value.map((chip) => (
            <Badge
              key={chip}
              variant="secondary"
              className="flex items-center gap-1 pr-1"
            >
              {chip}
              <button
                type="button"
                onClick={() => removeChip(chip)}
                className="ml-1 rounded-full p-0.5 hover:bg-muted-foreground/20"
                disabled={disabled}
              >
                <X className="h-3 w-3" />
              </button>
            </Badge>
          ))}
        </div>
      )}
    </div>
  );
}
