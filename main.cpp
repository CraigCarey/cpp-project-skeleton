#include <functional>
#include <iostream>

int main()
{
	// C++14 lambda init captures
	[out = std::ref(std::cout << "Hello")]() { out.get() << " World\n"; }();
}