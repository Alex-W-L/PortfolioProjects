import pandas as pd
import geopandas as gpd
from pathlib import Path

# Will be updated eventually to have an auto-determining path
BASE_PATH_TO_FOLDER = input("Please provide the path to the root folder of this project: ")

CSV_KANGLE = BASE_PATH_TO_FOLDER + "/data/raw/Portland Crime Data Raw.csv"
CSV_PPB = BASE_PATH_TO_FOLDER + "/data/raw/CrimeData-2023.csv"

# Ensuring to inform the user of what went wrong with the script if the file was not found
try: 
    df_kaggle = pd.read_csv(CSV_KANGLE, sep='\t')
    df_ppb = pd.read_csv(CSV_PPB)
except FileNotFoundError as e:
    print("File Not Found: Please provide the path to the root folder of this project")
    print(f"Path tried was: '{CSV_KANGLE}'")
    print("Example: C:/Users/TestUser/")
    exit(1)

# Naming unique-id column, creating datetime objects
df_kaggle = df_kaggle.rename(columns = {'Unnamed: 0': 'ID'})
for col in ['OccurDate', 'ReportDate']:
    df_ppb[col] = pd.to_datetime(df_ppb[col], errors='coerce').dt.strftime('%Y-%m-%d')
    df_kaggle[col] = pd.to_datetime(df_kaggle[col], errors='coerce').dt.strftime('%Y-%m-%d')

# Isolating a subset of the missing data from df_ppb and merging it into df_kaggle as a new dataframe, df
df_ppb_subset_missing = df_ppb[(df_ppb['ReportDate'] >= '2023-08-01') & (df_ppb['ReportDate'] <= '2023-12-31')]
starting_id = df_kaggle['ID'].max() + 1
df_ppb_subset_missing = df_ppb_subset_missing.copy()
df_ppb_subset_missing['ID'] = range(starting_id, starting_id + len(df_ppb_subset_missing))
df = pd.concat([df_kaggle, df_ppb_subset_missing], ignore_index=True)

# Converting Lat/Lon data from PPB to zipcode data utilizing shpefile from Portland City Open Data initiative
zip_gdf = gpd.read_file(f'{BASE_PATH_TO_FOLDER}data/supplemental/ZIP_Codes.shp')
crime_gdf = gpd.GeoDataFrame(
    df,
    geometry=gpd.points_from_xy(df['OpenDataLon'], df['OpenDataLat']),
    crs="EPSG:4326"
)
zip_gdf = zip_gdf.to_crs(crime_gdf.crs)
crime_with_zip = gpd.sjoin(crime_gdf, zip_gdf[['ZIPCODE', 'geometry']], how='left', predicate='within')
zip_data = crime_with_zip[['ID', 'ZIPCODE']]
df = df.merge(zip_data, on='ID', how='left')

# Creating a few additional columns for data analysis
df['ReportDate'] = pd.to_datetime(df['ReportDate'], errors='coerce')
df['OccurDate'] = pd.to_datetime(df['OccurDate'], errors='coerce')
df['OccurTime'] = pd.to_datetime(df['OccurTime'].astype(str).str.zfill(4), format='%H%M').dt.time
df['OccurDateTime'] = pd.to_datetime(df['OccurDate'].astype(str) + ' ' + df['OccurTime'].astype(str))
df['OccurHour'] = df['OccurDateTime'].dt.hour

# Uploading the resulting document to the processed data folder
df.to_csv(f"{BASE_PATH_TO_FOLDER}data/processed/Portland Crime Data with Zipcode Cleaned.csv", index=False)