import streamlit as st

st.set_page_config(
    page_title = 'Cardiovascular Prediction System'
)

# Create Navigation Bar
def Home():
    st.Page('home.py', title='Home')
    st.header('Home Page')
# st.header('Home Page')
    
pages = {
    "Home": {
        st.Page(Home)
    },
    "Models": {
        st.Page('app/logistic.py', title='Logistic'),
        st.Page('app/svm.py', title='SVM')
    }
}

pg = st.navigation(pages, position='top')
pg.run()