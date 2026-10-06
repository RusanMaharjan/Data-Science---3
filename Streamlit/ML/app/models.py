# import joblib

# LOGISTIC_MODEL_PATH = 'ML/models/Logistic/logistic_model.pkl'
# LOGISTIC_SCALER_PATH = 'ML/models/Logistic/logistic_scaler.pkl'

# SVM_MODEL_PATH = 'ML/models/SVM/svm_model.pkl'
# SVM_SCALER_PATH = 'ML/models/SVM/svm_scaler.pkl'

from pathlib import Path
import joblib

# Fetch for ML Folder
BASE_DIR = Path(__file__).resolve().parent.parent

LOGISTIC_MODEL_PATH = BASE_DIR / "models" / "Logistic" / "logistic_model.pkl"
LOGISTIC_SCALER_PATH = BASE_DIR / "models" / "Logistic" / "logistic_scaler.pkl"

SVM_MODEL_PATH = BASE_DIR / "models" / "SVM" / "svm_model.pkl"
SVM_SCALER_PATH = BASE_DIR / "models" / "SVM" / "svm_scaler.pkl"

def read_logistic_files():
    model = joblib.load(LOGISTIC_MODEL_PATH)
    scaler = joblib.load(LOGISTIC_SCALER_PATH)

    return model, scaler


def read_svm_files():
    model = joblib.load(SVM_MODEL_PATH)
    scaler = joblib.load(SVM_SCALER_PATH)
    
    return model, scaler