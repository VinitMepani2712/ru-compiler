define i64 @foo(i64 %a) {
entry:
    %a.alloc = alloca i64
    %b.alloc = alloca i64
    %c.alloc = alloca i64
    store i64 %a, ptr %a.alloc
    store i64 5, ptr %b.alloc
    store i64 0, ptr %c.alloc
    %t1 = load i64, ptr %a.alloc
    %cmp = icmp ult i64 %t1, 4
    br i1 %cmp, label %if.then, label %if.else

if.then:
    store i64 4, ptr %b.alloc
    br label %if.end

if.else:
    store i64 6, ptr %b.alloc
    br label %if.end

if.end:
    br label %while.cond

while.cond:
    %t2 = load i64, ptr %b.alloc
    %cmp1 = icmp ugt i64 %t2, 4
    br i1 %cmp1, label %while.body, label %while.end

while.body:
    %t3 = load i64, ptr %c.alloc
    %t4 = load i64, ptr %a.alloc
    %t5 = add i64 %t3, %t4
    store i64 %t5, ptr %c.alloc
    %t6 = load i64, ptr %b.alloc
    %t7 = sub i64 %t6, 1
    store i64 %t7, ptr %b.alloc
    br label %while.cond

while.end:
    %t8 = load i64, ptr %c.alloc
    ret i64 %t8
}
