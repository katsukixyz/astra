import pandas

data = pandas.read_csv("Global_Landslide_Catalog_Export.csv")
print(data["longitude"])
data = data[(data["longitude"] > 114.27789225) & 
    (data["longitude"] < 126.6049656) &
    (data["latitude"] > 4.5872945) &
    (data["latitude"] < 21.12188548)]

data = data[(data["longitude"] > 120) |
    (data["latitude"] > 8)]
# for x in data["country_name"]:
#     print(x)

data.to_csv("philippines.csv", index=False)