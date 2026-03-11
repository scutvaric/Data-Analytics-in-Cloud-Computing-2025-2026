import csv
import json
import os
from collections import Counter

# Lab parameter: change the threshold without changing the code
quality_threshold = int(os.environ.get("QUALITY_THRESHOLD", "7"))

# Default file name (produced by download_wine_quality.sh)
path = os.environ.get("DATA_FILE", "winequality-red.csv")

total = 0
alcohol_sum = 0.0
high_quality = 0
quality_counts = Counter()

# UCI winequality-* CSV files use ';' as delimiter
with open(path, newline="", encoding="utf-8") as f:
    r = csv.DictReader(f, delimiter=";")
    for row in r:
        total += 1
        alcohol_sum += float(row["alcohol"])
        q = int(row["quality"])
        quality_counts[q] += 1
        if q >= quality_threshold:
            high_quality += 1

avg_alcohol = round(alcohol_sum / total, 3) if total else 0.0
most_common_quality, most_common_count = quality_counts.most_common(1)[0] if total else (None, 0)

out = {
    "dataset": path,
    "quality_threshold": quality_threshold,
    "total_rows": total,
    "avg_alcohol": avg_alcohol,
    "high_quality_count": high_quality,
    "most_common_quality": {"quality": most_common_quality, "count": most_common_count},
}

print(json.dumps(out, indent=2))
