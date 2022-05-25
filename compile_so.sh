apt-get install gcc-5 g++-5
ln -s /usr/bin/gcc-5 /usr/local/cuda/bin/gcc
ln -s /usr/bin/g++-5 /usr/local/cuda/bin/g++

TF_INC=$(python -c 'import tensorflow as tf; print(tf.sysconfig.get_include())')
TF_LIB=$(python -c 'import tensorflow as tf; print(tf.sysconfig.get_lib())')

cd /home/testdir/PCAN/tf_ops/sampling/

nvcc tf_sampling_g.cu -o tf_sampling_g.cu.o -c -O2 -DGOOGLE_CUDA=1 -x cu -Xcompiler -fPIC -Wno-deprecated-gpu-targets

export TF_PREFIX="/root/.pyenv/versions/3.6.5/lib/python3.6/site-packages/tensorflow"
export CUDA_PREFIX="/usr/local/cuda-8.0"

g++ -w -std=c++11 tf_sampling.cpp tf_sampling_g.cu.o -o tf_sampling_so.so -shared -fPIC \
    -I $TF_PREFIX"/include" -I $CUDA_PREFIX"/include" -I $TF_PREFIX"/include/external/nsync/public" \
    -lcudart -L $CUDA_PREFIX"/lib64/" -L $TF_PREFIX \
    -O2 -D_GLIBCXX_USE_CXX11_ABI=0 -I$TF_INC/external/nsync/public -L$TF_LIB -ltensorflow_framework

cd /home/testdir/PCAN/tf_ops/3d_interpolation/

g++ -w -std=c++11 tf_interpolate.cpp -o tf_interpolate_so.so -shared -fPIC \
    -I $TF_PREFIX"/include" -I $CUDA_PREFIX"/include" -I $TF_PREFIX"/include/external/nsync/public" \
    -lcudart -L $CUDA_PREFIX"/lib64/" -L $TF_PREFIX \
    -ltensorflow_framework -O2 -D_GLIBCXX_USE_CXX11_ABI=0 -I$TF_INC/external/nsync/public -L$TF_LIB -ltensorflow_framework

cd /home/testdir/PCAN/tf_ops/grouping/

nvcc tf_grouping_g.cu -o tf_grouping_g.cu.o -c -O2 -DGOOGLE_CUDA=1 -x cu -Xcompiler -fPIC -Wno-deprecated-gpu-targets

g++ -w -std=c++11 tf_grouping.cpp tf_grouping_g.cu.o -o tf_grouping_so.so -shared -fPIC \
    -I $TF_PREFIX"/include" -I $CUDA_PREFIX"/include" -I $TF_PREFIX"/include/external/nsync/public" \
    -lcudart -L $CUDA_PREFIX"/lib64/" -L $TF_PREFIX \
    -ltensorflow_framework -O2 -D_GLIBCXX_USE_CXX11_ABI=0 -I$TF_INC/external/nsync/public -L$TF_LIB -ltensorflow_framework




