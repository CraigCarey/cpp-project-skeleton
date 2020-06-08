// g++ memory.cpp -Wall -Wextra -g
// clang++  memory.cpp -Wall -Wextra -g -fsanitize=memory -fsanitize-memory-track-origins

#include <iostream>

void set_val(bool &b, const int val)
{
    if (val > 1)
    {
        b = false;
    }
}

int main(const int argc, const char *[])
{
    bool b;
    set_val(b, argc);

    // b could be uninitialised here
    if (b)
    {
        std::cout << "Value set\n";
    }
}
