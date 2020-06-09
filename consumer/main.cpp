#include <functional>
#include <iostream>

//#include <skeleton/skeleton.hpp>

int main()
{
    // C++14 lambda init captures
    [out = std::ref(std::cout << "Hello")]() { out.get() << " World\n"; }();

    //    std::cout << skeleton::get_md5_sum() << '\n';
}
