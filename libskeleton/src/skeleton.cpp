#include "skeleton/skeleton.hpp"

#include <iostream>

namespace skeleton {

boost::optional<std::string> get_md5_sum()
{
    // TODO: Add arbitrary internal boost use (regex is broken under clang)
    return std::string("d41d8cd98f00b204e9800998ecf8427e");
}

boost::chrono::system_clock::time_point get_sys_clock()
{
    return boost::chrono::system_clock::now();
}

}  // namespace skeleton
