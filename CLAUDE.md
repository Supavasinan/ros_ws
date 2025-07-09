# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a ROS 2 workspace containing sensor packages for robotic applications:

- **ldrobot-lidar-ros2**: Complete LiDAR package for LDRobot 2D DToF lidars (LD19, LD06, STL27L)
- **ros2_mpu6050**: IMU sensor package for MPU6050 integration

## Build System

### Standard Build Commands
```bash
# Install dependencies
rosdep install --from-paths src --ignore-src -r -y

# Build all packages
colcon build --symlink-install --cmake-args=-DCMAKE_BUILD_TYPE=Release

# Build specific package
colcon build --packages-select <package_name>

# Source the workspace
source install/local_setup.bash
```

### Testing
```bash
# Run tests
colcon test

# View test results
colcon test-result --verbose
```

### Code Formatting
```bash
# Format code before submitting PRs
ament_uncrustify --reformat src
```

## Package Architecture

### LDRobot LiDAR Package Structure
- **ldlidar**: Meta package
- **ldlidar_component**: ROS 2 lifecycle-based component with driver
- **ldlidar_node**: Launch files and configurations

The LiDAR driver follows ROS 2 lifecycle patterns and requires proper state transitions:
1. `UNCONFIGURED` → `INACTIVE` (configure)
2. `INACTIVE` → `ACTIVE` (activate)

### Launch Files and Common Patterns
```bash
# Basic lidar launch
ros2 launch ldlidar_node ldlidar_bringup.launch.py

# With lifecycle manager
ros2 launch ldlidar_node ldlidar_with_mgr.launch.py

# With RViz2 visualization
ros2 launch ldlidar_node ldlidar_rviz2.launch.py

# SLAM example
ros2 launch ldlidar_node ldlidar_slam.launch.py

# MPU6050 IMU sensor
ros2 launch ros2_mpu6050 ros2_mpu6050.launch.py
```

## Development Environment

### DevContainer Setup
The repository includes DevContainer configuration for ROS 2 Humble on ARM64 architecture with:
- Privileged mode for device access
- Host networking
- Device mounting for sensor access

### Hardware Requirements
- **LiDAR**: Requires udev rules installation via `scripts/create_udev_rules.sh`
- **MPU6050**: I2C interface, typically requires calibration via `ros2 run ros2_mpu6050 ros2_mpu6050_calibrate`

## Key Configuration Files

### LiDAR Configuration
- Parameters: `ldlidar_node/params/ldlidar.yaml`
- Lifecycle management: `ldlidar_node/params/lifecycle_mgr.yaml`
- SLAM config: `ldlidar_node/params/slam_toolbox.yaml`

### MPU6050 Configuration
- Parameters: `ros2_mpu6050/config/params.yaml`
- Requires calibration values for gyro and accelerometer offsets

## TF Transforms
- LiDAR: Provides `ldlidar_base` → `ldlidar_link` transform
- Integration requires `base_link` → `ldlidar_base` transform from robot description

## Dependencies
- ROS 2 Humble (primary target)
- Nav2 utilities for lifecycle management
- SLAM Toolbox for mapping capabilities
- libudev-dev system dependency for LiDAR