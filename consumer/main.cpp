#include <functional>
#include <iostream>

#include <boost/optional.hpp>

#include <skeleton/skeleton.hpp>

int main()
{
    // C++14 lambda init captures
    [out = std::ref(std::cout << "Hello")]() { out.get() << " World\n"; }();

    boost::optional<std::string> md5 = skeleton::get_md5_sum();

    std::cout << "MD5: " << *md5 << '\n';

    auto time_point = skeleton::get_sys_clock();

    std::cout << "Time since epoch (ns): " << time_point.time_since_epoch() << '\n';
}
