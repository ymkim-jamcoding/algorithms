# make number시 다음과 같은 에러인 경우
```shell
boj/number/_solve_number.cpp: In function ‘int _solve()’:
boj/number/_solve_number.cpp:8:1: error: no return statement in function returning non-void [-Werror=return-type]
```
```shell
boj/number/_solve_number.cpp:9:1: error: non-void function does not return a value [-Werror,-Wreturn-type]
    9 | }
      | ^
```
- 해당 문제의 cpp 파일에 `return 0;`을 추가해주세요