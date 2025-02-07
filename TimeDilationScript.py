# Script developed by Anum Pirkani
# For details, please contact anum.apirkani@gmail.com

import numpy as np
import matplotlib.pyplot as plt
import matplotlib.animation as animation

# Constants
SpeedLight = 299792458
SpeedMovingTarget1 = 0.8 * SpeedLight
SpeedMovingTarget2 = 0.99 * SpeedLight
LorentzFactor1 = 1 / np.sqrt(1 - (SpeedMovingTarget1 ** 2 / SpeedLight ** 2))
LorentzFactor2 = 1 / np.sqrt(1 - (SpeedMovingTarget2 ** 2 / SpeedLight ** 2))

VelocityRatioValues = np.linspace(0, 1, 600)
LorentzFactorValues = 1 / np.sqrt(1 - VelocityRatioValues**2)

fig, axes = plt.subplots(1, 3, figsize=(15, 6), facecolor=(0.1, 0.1, 0.1))
plt.subplots_adjust(wspace=0.3)

# Lorentz Factor vs. Velocity
ax1 = axes[0]
ax1.set_xlim(0, 1)
ax1.set_ylim(0.9, 7)
ax1.set_xlabel("Velocity Ratio (v/c)", fontsize=12, fontweight="bold", color="white")
ax1.set_ylabel("Time Dilation (γ)", fontsize=12, fontweight="bold", color="white")
ax1.grid(True, linestyle="--", alpha=0.6)
ax1.set_facecolor((0.2, 0.2, 0.2))
ax1.tick_params(colors="white")
lorentz_plot, = ax1.plot([], [], "m", linewidth=5)

# Time Progress
ax2 = axes[1]
ax2.set_xlim(0, 60)
ax2.set_ylim(0, 60)
ax2.set_xlabel("Stationary Time (s)", fontsize=12, fontweight="bold", color="white")
ax2.set_ylabel("Elapsed Time (s)", fontsize=12, fontweight="bold", color="white")
ax2.grid(True, linestyle="--", alpha=0.6)
ax2.set_facecolor((0.2, 0.2, 0.2))
ax2.tick_params(colors="white")
stationary_plot, = ax2.plot([], [], "b", linewidth=5, label="Stationary Time")
moving_plot1, = ax2.plot([], [], "r", linewidth=5, label="Moving: 0.8c")
moving_plot2, = ax2.plot([], [], "g", linewidth=5, label="Moving: 0.99c")
ax2.legend(loc="upper left", fontsize=10, facecolor="white", edgecolor="white")

# Clock
ax3 = axes[2]
ax3.set_xlim(-2, 2)
ax3.set_ylim(-1.5, 2)
ax3.set_xticks([])
ax3.set_yticks([])
ax3.set_facecolor((0.2, 0.2, 0.2))

theta    = np.linspace(0, 2 * np.pi, 100)
x_circle = 0.4 * np.cos(theta)
y_circle = 0.4 * np.sin(theta)

ax3.fill(0 + x_circle, 1.2 + y_circle, "b")
ax3.fill(-0.8 + x_circle, -0.6 + y_circle, "r")
ax3.fill(0.8 + x_circle, -0.6 + y_circle, "g")

h1, = ax3.plot([0, 0], [1.2, 1.5], "k", linewidth=4)
h2, = ax3.plot([-0.8, -0.8], [-0.6, -0.3], "k", linewidth=4)
h3, = ax3.plot([0.8, 0.8], [-0.6, -0.3], "k", linewidth=4)

ax3.text(0, 1.8, "Stationary Clock", ha="center", fontsize=12, color="white")
ax3.text(-0.8, 0.1, "Moving: 0.8*c", ha="center", fontsize=12, color="white")
ax3.text(0.8, 0.1, "Moving: 0.99*c", ha="center", fontsize=12, color="white")

text_stationary = ax3.text(0, 0.6, "0.00 s", ha="center", fontsize=12, color="white")
text_moving1 = ax3.text(-0.8, -1.2, "0.00 s", ha="center", fontsize=12, color="white")
text_moving2 = ax3.text(0.8, -1.2, "0.00 s", ha="center", fontsize=12, color="white")

stationary_time = []
moving_time1 = []
moving_time2 = []

def update(frame):
    time_stationary = frame * 0.1
    time_moving1 = time_stationary / LorentzFactor1
    time_moving2 = time_stationary / LorentzFactor2

    # Update Lorentz Factor Graph
    lorentz_plot.set_data(VelocityRatioValues[:frame], LorentzFactorValues[:frame])

    # Update Time Progress Graph
    stationary_time.append(time_stationary)
    moving_time1.append(time_moving1)
    moving_time2.append(time_moving2)

    stationary_plot.set_data(stationary_time, stationary_time)
    moving_plot1.set_data(stationary_time, moving_time1)
    moving_plot2.set_data(stationary_time, moving_time2)

    # Update Clock Hands
    h1.set_data([0, 0.3 * np.cos(-time_stationary * np.pi / 30 + np.pi / 2)], 
                [1.2, 1.2 + 0.3 * np.sin(-time_stationary * np.pi / 30 + np.pi / 2)])

    h2.set_data([-0.8, -0.8 + 0.3 * np.cos(-time_moving1 * np.pi / 30 + np.pi / 2)], 
                [-0.6, -0.6 + 0.3 * np.sin(-time_moving1 * np.pi / 30 + np.pi / 2)])

    h3.set_data([0.8, 0.8 + 0.3 * np.cos(-time_moving2 * np.pi / 30 + np.pi / 2)], 
                [-0.6, -0.6 + 0.3 * np.sin(-time_moving2 * np.pi / 30 + np.pi / 2)])

    # Update Time Text
    text_stationary.set_text(f"{time_stationary:.2f} s")
    text_moving1.set_text(f"{time_moving1:.2f} s")
    text_moving2.set_text(f"{time_moving2:.2f} s")

    return lorentz_plot, stationary_plot, moving_plot1, moving_plot2, text_stationary, text_moving1, text_moving2

anim = animation.FuncAnimation(fig, update, frames=600, interval=30, blit=True)

anim.save("TimeDilationPython.gif", writer="pillow", fps=30)

plt.show()
