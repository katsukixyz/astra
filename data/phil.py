import pandas

import matplotlib.pyplot as plt
data = pandas.read_csv("philippines_old.csv")

plt.scatter(data["longitude"], data["latitude"])
plt.show()