#include "skeleton/skeleton.hpp"

#include <iostream>

#include <boost/regex.hpp>

namespace skeleton {

boost::optional<std::string> get_md5_sum()
{
    // Arbitrary internal boost use
    boost::regex expr{R"(\b[a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}\b)"};
    return std::string("d41d8cd98f00b204e9800998ecf8427e");
}

boost::chrono::system_clock::time_point get_sys_clock()
{
    return boost::chrono::system_clock::now();
}

}  // namespace skeleton
