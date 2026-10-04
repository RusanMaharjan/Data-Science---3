import streamlit as st
import pandas as pd
import plotly.express as px
from style import headerStyle, subHeaderStyle

# Page Configuration
st.set_page_config(
    page_title="Pizza Sales Dashboard",
    page_icon=":pizza:",
    layout='wide'
)

# Import Data and store all data in cache memory
@st.cache_data
def load_data():
    df = pd.read_csv('pizza_sales.csv')
    df['order_date'] = pd.to_datetime(df['order_date'], format='mixed')
    df['month_name'] = df['order_date'].dt.month_name()
    return df

df = load_data()


# Create sidebar
st.sidebar.header('🔍Filter data')

# Filter data using pizza size
ps = st.sidebar.multiselect(
    'Select Pizza Size',
    options=df['pizza_size'].unique(),
    default=df['pizza_size'].unique()
)

# Filter data using pizza category
pc = st.sidebar.multiselect(
    'Select Pizza Category',
    options=df['pizza_category'].unique(),
    default=df['pizza_category'].unique()
)

month = st.sidebar.multiselect(
    'Select Month',
    options=df['month_name'].unique(),
    default=df['month_name'].unique()
)


# Streamlit Query
# select * from sales where pizza_sales = @ps
df_selection = df.query(
    "pizza_size == @ps & pizza_category == @pc & month_name == @month"
)

# Show empty dashboard if filter is empty
if df_selection.empty:
    st.warning("No data matches the filter.")
    st.stop()


# Dashboard
# st.header('Pizza Sales Dashboard')
st.markdown(headerStyle('Pizza Sales Dashboard'), unsafe_allow_html=True)
st.markdown(subHeaderStyle('KPI', "📊"), unsafe_allow_html=True)
# st.subheader(':chart_with_upwards_trend: KPI')

# Calculation of KPIs
total_reveue = df_selection['total_price'].sum()
total_pizza_sold = df_selection['quantity'].sum()
total_orders = df_selection['order_id'].nunique()
average_order_value = total_reveue / total_orders
average_pizza_per_order = total_pizza_sold / total_orders


kpi1, kpi2, kpi3, kpi4, kpi5 = st.columns(5)

with kpi1:
    st.write('Total Revenue')
    st.write(f'${total_reveue:,.2f}')
    # st.metric(label='Total Revenue', value=f'${total_reveue:,.2f}')

with kpi2:
    st.write('Total Pizza Sold')
    st.write(f'{total_pizza_sold}')

with kpi3:
    st.write('Total Orders')
    st.write(f'{total_orders}')

with kpi4:
    st.write('Average Order Value')
    st.write(f'{average_order_value:,.2f}')

with kpi5:
    st.write('Average Pizza Per Order')
    st.write(f'{average_pizza_per_order:,.2f}')

# Visualization
st.markdown(subHeaderStyle('Visualization'), unsafe_allow_html=True)

chart1, chart2 = st.columns(2)
# Bar Chart
# Total Pizza Sold by Pizza Category
with chart1:
    category_quantity = df_selection.groupby(
        'pizza_category')['quantity'].sum().reset_index()

    fig = px.bar(
        category_quantity,
        x='pizza_category',
        y='quantity',
        title='Total Pizza Sold by Pizza Category',
        labels={'pizza_category':'Pizza Category',
                'quantity': 'Quantity'}
    )
    st.plotly_chart(fig)
    
with chart2:
    revenue_size = df_selection.groupby(
        'pizza_size')['total_price'].sum().reset_index()
    
    fig2 = px.pie(
        revenue_size,
        names="pizza_size",
        values="total_price",
        hole=0.7,
        title='Total Revenue by Pizza Size'
    )
    fig2.update_traces(textinfo='percent + label')
    st.plotly_chart(fig2)
    

chart3, chart4 = st.columns(2)
with chart3:
    top_5 = df_selection.groupby(
        'pizza_name')['total_price'].sum().reset_index().sort_values(
            by='total_price', ascending=False
        ).head()

    fig3 = px.bar(
        top_5,
        x='total_price',
        y='pizza_name',
        orientation='h',
        title='Top 5 Best Selling Pizzas'
    )
    st.plotly_chart(fig3)
    
    
    
## Search Bar
st.markdown(subHeaderStyle('Data View'), unsafe_allow_html=True)

search_col1, search_col_2 = st.columns(2)

search_columns = {
    'pizza_size': 'Pizza Size', 'pizza_category': 'Pizza Category', 'pizza_name': 'Pizza Name'
}

with search_col1:
    search_from = st.selectbox(
        'Search Through',
        options = list(search_columns.keys()),
        format_func = lambda x : search_columns[x]
    )  

with search_col_2:
    query = st.text_input(f'Search: {search_columns[search_from]}', placeholder='Eg:. Classic / S / The Greek Pizza')

if st.button('Filter🔎'):
    if query:
        result = df[df[search_from].astype(str).str.contains(query, case=False)][['pizza_name', 'pizza_size', 'pizza_category']]
    else:
        st.warning('No data found.')
        result = df[['pizza_name', 'pizza_size', 'pizza_category']]
        
    st.dataframe(result)    
else:
    st.dataframe(df[['pizza_name', 'pizza_size', 'pizza_category']])