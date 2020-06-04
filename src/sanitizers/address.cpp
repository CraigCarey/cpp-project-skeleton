// g++ sanitizers.cpp -Wall -Werror -fsanitize=address -g
// clang++ sanitizers.cpp -fsanitize=address -g
#include <string>

int main()
{
    const char *names[] = {"Bob", "Fred"};
    std::string last_arg = names[2];
    return last_arg.size();
}
