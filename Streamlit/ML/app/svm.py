import streamlit as st
import numpy as np
from models import read_svm_files

svm_model, svm_scaler = read_svm_files()

st.header('Cardiovascular Disease Prediction')
st.subheader('Using Support Vector Classifier')

st.sidebar.header(
    'Input Features'
)

age = st.sidebar.slider(
    'Age',
    max_value = 70,
    min_value = 28,
    value=32,
    step=1
)

# Gender
gender_dict = {1: 'Female', 2: 'Male'}
gender = st.sidebar.radio(
    'Gender',
    options = list(gender_dict.keys()),
    format_func = lambda x : gender_dict.get(x)
)

# height
height = st.sidebar.slider(
    'Height',
    max_value = 185,
    min_value = 145,
    step = 1,
    value = 155
)

# weight
weight = st.sidebar.slider(
    'Weight',
    max_value = 120,
    min_value = 45,
    step = 1,
    value = 60
)

# systolic pressure
ap_hi = st.sidebar.slider(
    'Systolic Pressure',
    max_value = 200,
    min_value = 90,
    step = 1,
    value = 120
)

# Di-Systolic Pressure
ap_lo = st.sidebar.slider(
    'DiSystolic Pressure',
    max_value = 90,
    min_value = 50,
    step = 1,
    value = 80
)

# cholesterol
cholesterol_dict = {1: 'Low Cholesterol', 2: 'Mild Cholesterol', 3: 'High Cholesterol'}
cholesterol = st.sidebar.radio(
    'Cholesterol',
    options = list(cholesterol_dict.keys()),
    format_func = lambda x : cholesterol_dict.get(x)
)

# gluc
gluc_dict = {1: 'Low Glucose', 2: 'Mild Glucose', 3: 'High Glucose'}
gluc = st.sidebar.radio(
    'Glucose',
    options = list(gluc_dict.keys()),
    format_func = lambda x : gluc_dict.get(x)
)

# 'smoke', 
smoke_dict = {0: 'Doesnot Smoke', 1: 'Does Smoke'}
smoke = st.sidebar.radio(
    'Smoke',
    options = list(smoke_dict.keys()),
    format_func = lambda x : smoke_dict.get(x)
)

# alco
alco_dict = {0: 'Doesnot Drink', 1: 'Does Drink'}
alco = st.sidebar.radio(
    'Alcohol Consumption',
    options = list(alco_dict.keys()),
    format_func = lambda x : alco_dict.get(x)
)

# active
active_dict = {0: 'Does PA', 1: 'Doesnot do PA'}
active = st.sidebar.radio(
    'Physical Activities (PA)',
    options = list(active_dict.keys()),
    format_func = lambda x: active_dict.get(x)
)

if st.button('Predict Cardio'):
    input_data = np.array([[
        age, gender, height, weight, ap_hi, ap_lo, cholesterol, gluc, smoke, alco, active
    ]])
    input_scale = svm_scaler.transform(input_data)
    prediction = svm_model.predict(input_scale)[0]
    
    if prediction == 0:
        st.write('No cardio disease found.')
        st.success('Likely to be Healthy.')
    else:
        st.write('Cardio disease found.')
        st.warning('Likely to be UnHealthy.')
    