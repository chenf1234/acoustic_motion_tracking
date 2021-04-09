# acoustic motion tracking

测距相关的代码在`disestimate`文件夹中，包括三种方法：fmcw、多普勒频移和单频正弦波的相位，保存在对应名称的子文件夹下

`nlopt`文件夹中为使用非线性优化库[`NLOPT`](https://nlopt.readthedocs.io/en/latest/)所需的代码，不是我写的，`optimize`文件夹中的代码用到了该库

`testfiles`保存测试文件

`wavfiles`保存用于测试的音频文件

`util`保存工具代码，包括FFT、STFT、上采样等等

`filter`保存滤波器代码，fir开头的文件为FIR滤波器，my开头的文件为IIR滤波器