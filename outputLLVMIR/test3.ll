define i64 @foo(i64 %a) {
entry:
    %a.alloc = alloca i64
    %b.alloc = alloca i64
    %c.alloc = alloca i64
    store i64 %a, ptr %a.alloc
    store i64 1, ptr %b.alloc
    store i64 0, ptr %c.alloc
    br label %while.cond

while.cond:
    %t1 = load i64, ptr %a.alloc
    %cmp = icmp ugt i64 %t1, 1
    br i1 %cmp, label %while.body, label %while.end

while.body:
    %t2 = load i64, ptr %c.alloc
    %t3 = load i64, ptr %b.alloc
    %t4 = add i64 %t2, %t3
    store i64 %t4, ptr %c.alloc
    %t5 = load i64, ptr %a.alloc
    %t6 = sub i64 %t5, 1
    store i64 %t6, ptr %a.alloc
    br label %while.cond

while.end:
    %t7 = load i64, ptr %c.alloc
    %cmp1 = icmp ult i64 %t7, 5
    br i1 %cmp1, label %if.then, label %if.else

if.then:
    %t8 = load i64, ptr %c.alloc
    %t9 = add i64 %t8, 2
    store i64 %t9, ptr %c.alloc
    br label %if.end

if.else:
    %t10 = load i64, ptr %c.alloc
    store i64 %t10, ptr %c.alloc
    br label %if.end

if.end:
    %t11 = load i64, ptr %c.alloc
    ret i64 %t11
}
