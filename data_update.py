import os
import requests
import subprocess


# Kaggle dataset details
KAGGLE_DATASET = "meraxes10/fantasy-premier-league-dataset-2024-2025"
EPL_CSV_URL = "https://datahub.io/core/english-premier-league/r/season-2425.csv"

SAVE_DIR = "data"
os.makedirs(SAVE_DIR, exist_ok=True)

# Function to download DataHub CSV
def download_csv(url, filename):
    file_path = os.path.join(SAVE_DIR, filename)
    try:
        response = requests.get(url, stream=True)
        response.raise_for_status()
        with open(file_path, "wb") as file:
            for chunk in response.iter_content(chunk_size=8192):
                file.write(chunk)
        print(f"✅ Downloaded {filename} successfully.")
    except requests.exceptions.RequestException as e:
        print(f"❌ Failed to download {filename}: {e}")

# Function to run a Python script
def run_script(script_name):
    """Runs a Python script and handles errors."""
    print(f"🔄 Running {script_name}...")
    result = subprocess.run(["python", script_name], capture_output=True, text=True)

    if result.returncode == 0:
        print(f"✅ {script_name} ran successfully.")
    else:
        print(f"❌ Error in {script_name}: {result.stderr}")

# Download DataHub EPL stats
download_csv(EPL_CSV_URL, "epl_stats.csv")

# Ensure Kaggle API is installed
try:
    import kaggle
except ImportError:
    subprocess.run(["pip", "install", "kaggle"])

# Download Kaggle dataset
print("🔄 Downloading Kaggle dataset...")

kaggle_command = ["kaggle", "datasets", "download", "-d", KAGGLE_DATASET, "-p", SAVE_DIR, "--unzip"]
result = subprocess.run(kaggle_command, capture_output=True, text=True)

if result.returncode == 0:
    print("✅ Kaggle dataset downloaded successfully!")

    # Run players.py to process the dataset and update fpl_picks.db
    run_script("players.py")  
    run_script("export.py")

else:
    print(f"❌ Failed to download Kaggle dataset: {result.stderr}")





