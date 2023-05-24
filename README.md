## Aircraft Information System Design

------
[**English**](README.md) | [**中文简体**](README.zh-CN.md) 


This repository contains the course materials for "Aircraft Information System Design" in the Aircraft Control and Information Engineering program.


### Contents
The project includes two main parts:

####  Voice Signal Acquisition and Processing Design
- Utilize the built-in sound card of a computer to capture voice signals.

- Display the time-domain and frequency-domain plots of the voice signals.

- Apply digital filtering techniques to enhance the quality of the voice signals.

Perform time-frequency analysis (spectrogram) of the voice signals.

###  Signal Simulation Design for Aircraft Communication, Navigation, and Surveillance System based on SDR

#### Simulate the functionality of two-way communication using amplitude modulation (AM) or single-sideband modulation (SSB) techniques

- Gain an understanding of the basic principles of high-frequency/very high-frequency communication systems.

- Generate a data file to implement the transmission and reception of simulated signals.

#### Very High Frequency Omni-Directional Range (VOR) System Design Experiment
- Simulate the transmission and reception of signals between the aircraft and ground-based VOR systems.

- Implement the simulation of direction finding functionality.
Generate standardized signals for different VOR relative bearings (various degrees).

#### Instrument Landing System (ILS) Design Experiment
- Simulate the interaction between the onboard ILS system and the ground-based ILS system.
- Perform simulation of heading and glide slope deviation measurements.

#### Air Traffic Control (ATC) Transponder System Design Experiment(not completed)
- Simulate the interaction between the onboard transponder system and the ground-based secondary radar system.
- Implement identification of interrogation and response pulses.


## Implementation Approach
The project will utilize Software-Defined Radio (SDR) technology, which allows various communication modules to be implemented using software on a general-purpose hardware platform.


#### Disclaimer
- This project is provided for educational purposes only. It is not an official release and should be used at your own risk.

- This program is only applicable to Civil Aviation College courses. Please refer to [Design of Aircraft Information System](https://gitee.com/aircraft-is-design/aircraft-information-system-design) for the course requirements of the same name.

- For more information and detailed documentation, please refer to the individual directories and files within this repository，especially [Documentation](OutlineOfCode.md) and [Example Report](example.pdf).

#### License
[MIT](LICENSE) © lihanshu
