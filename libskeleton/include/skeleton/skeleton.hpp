#pragma once

#include <string>

#include <boost/chrono.hpp>
#include <boost/optional.hpp>

namespace skeleton {

boost::optional<std::string> get_md5_sum();

boost::chrono::system_clock::time_point get_sys_clock();

}  // namespace skeleton
