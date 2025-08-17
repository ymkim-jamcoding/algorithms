
#include <iostream>
#ifdef LOCAL
    #define LOG std::clog
#else
    struct nullstream : std::ostream {
        nullstream() : std::ostream(nullptr){}
    };
    nullstream LOG;
#endif

//--------------------------------------------

using namespace std;

#include <iostream>

int main()
{
    return 0; 
}