# file used to convert model to pickle file

from app.models import svm_cardio

if __name__ == '__main__':
    svm_cardio()
    print('Model and Scaler data saved successfully.')