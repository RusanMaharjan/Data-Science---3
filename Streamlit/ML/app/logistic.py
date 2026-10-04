import streamlit as st

st.header('Cardiovascular Disease Prediction')
st.subheader('Using Logistic Regression')


# age = st.sidebar.text_input('Age', placeholder='Enter your age')

age = st.sidebar.slider(
    'Age',
    max_value = 70,
    min_value = 28,
    value=32,
    step=1
)