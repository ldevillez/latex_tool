import matplotlib.pyplot as plt
import numpy as np


a = 2
b = -0.4
c = 2.646
d = -1.64
e = 0.2


r = (e**2 + (c-a)**2/4 + (d-b)**2/4) / (2*e)


m = (d - b)/(c-a)
alpha = np.arctan(1/m)

rx = (a+c)/2 + np.cos(alpha)*(r-e)
ry = (b+d)/2 - np.sin(alpha)*(r-e)

print(r)

theta1 = 180*np.arctan2(b-ry,a-rx)/np.pi
theta2 = 180*np.arctan2(d-ry,c-rx)/np.pi
print(theta1)
print(theta2)


fig, axs = plt.subplots(1, 1)

plt.plot([a, c, rx, a],[b, d, ry, b])
plt.plot([(a+c)/2, rx],[(b+d)/2, ry])

axs.set_aspect('equal')

plt.show()
