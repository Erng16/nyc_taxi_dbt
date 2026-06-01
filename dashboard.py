import streamlit as st
import pandas as pd
import plotly.express as px

# page config
st.set_page_config(
    page_title='NYC Taxi Analytics',
    layout='wide'
)

# load data from CSV
metrics = pd.read_csv('data/metrics.csv')
monthly = pd.read_csv('data/monthly_trends.csv')
payments = pd.read_csv('data/payment_methods.csv')
hourly = pd.read_csv('data/hourly_demand.csv')
categories = pd.read_csv('data/trip_category_summary.csv')

# header
st.title('NYC Taxi Analytics Dashboard')
st.markdown('Analysis of NYC Yellow Taxi trips from **January to March 2024**')
st.divider()

# overview metrics
col1, col2, col3, col4, col5 = st.columns(5)
col1.metric('Total Trips', f"{metrics['total_trips'][0]:,}")
col2.metric('Total Revenue', f"${metrics['total_revenue'][0]:,}")
col3.metric('Avg Fare', f"${metrics['avg_fare'][0]}")
col4.metric('Avg Distance', f"{metrics['avg_distance'][0]} mi")
col5.metric('Avg Duration', f"{metrics['avg_duration'][0]} min")
st.divider()

# row 1
col1, col2 = st.columns(2)

with col1:
    st.subheader('Monthly Trip Volume')
    monthly['pickup_month'] = monthly['pickup_month'].map({1: 'January', 2: 'February', 3: 'March'})
    fig = px.bar(monthly, x='pickup_month', y='total_trips',
             color='pickup_month',
             labels={'total_trips': 'Total Trips', 'pickup_month': 'Month'})
    st.plotly_chart(fig, use_container_width=True)

with col2:
    st.subheader('Payment Methods')
    fig2 = px.pie(payments, names='payment_method', values='total_trips')
    st.plotly_chart(fig2, use_container_width=True)

st.divider()

# row 2
st.subheader('Trip Volume by Hour and Day of Week')
fig3 = px.line(hourly, x='pickup_hour', y='total_trips',
               color='day_of_week',
               labels={'pickup_hour': 'Hour of Day', 'total_trips': 'Total Trips', 'day_of_week': 'Day'})

fig3.update_xaxes(
    tickvals=list(range(24)),
    ticktext=[f'{h:02d}:00' for h in range(24)]
)

st.plotly_chart(fig3, use_container_width=True)
st.divider()

# row 3
col1, col2 = st.columns(2)

with col1:
    st.subheader('Trip Category Breakdown')
    fig4 = px.bar(categories, x='trip_category', y='total_trips',
              color='trip_category',
              color_discrete_map={
                  'Short (<1 mile)': '#FFEDA0',
                  'Medium (1-5 miles)': '#FEB24C',
                  'Long (5-15 miles)': '#F03B20',
                  'Very Long (>15 miles)': '#BD0026'
              },
              labels={'trip_category': 'Category', 'total_trips': 'Total Trips'})
    st.plotly_chart(fig4, use_container_width=True)

with col2:
    st.subheader('Avg Fare by Trip Category')
    fig5 = px.bar(categories, x='trip_category', y='avg_fare',
                  color='trip_category',
                  color_discrete_map={
                  'Short (<1 mile)': '#FFEDA0',
                  'Medium (1-5 miles)': '#FEB24C',
                  'Long (5-15 miles)': '#F03B20',
                  'Very Long (>15 miles)': '#BD0026'
              },
                  labels={'trip_category': 'Category', 'avg_fare': 'Avg Fare ($)'})
    st.plotly_chart(fig5, use_container_width=True)