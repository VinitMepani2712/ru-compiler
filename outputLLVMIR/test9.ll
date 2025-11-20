define i64 @foo(i64 %a) {
entry:
    %a.alloc = alloca i64
    %b.alloc = alloca i64
    %c.alloc = alloca i64
    %d.alloc = alloca i64
    store i64 %a, ptr %a.alloc
    store i64 1, ptr %b.alloc
    store i64 2, ptr %c.alloc
    %t1 = load i64, ptr %a.alloc
    %t2 = mul i64 %t1, 3
    store i64 %t2, ptr %d.alloc
    %t3 = load i64, ptr %d.alloc
    %cmp = icmp ugt i64 %t3, 6
    br i1 %cmp, label %if.then, label %if.else

if.then:
    %t4 = load i64, ptr %d.alloc
    %t5 = load i64, ptr %a.alloc
    %t6 = sub i64 %t4, %t5
    store i64 %t6, ptr %c.alloc
    br label %if.end

if.else:
    %t7 = load i64, ptr %d.alloc
    %t8 = load i64, ptr %a.alloc
    %t9 = add i64 %t7, %t8
    store i64 %t9, ptr %c.alloc
    br label %if.end

if.end:
    br label %while.cond

while.cond:
    %t10 = load i64, ptr %c.alloc
    %cmp1 = icmp ugt i64 %t10, 3
    br i1 %cmp1, label %while.body, label %while.end

while.body:
    %t11 = load i64, ptr %b.alloc
    %t12 = add i64 %t11, 1
    store i64 %t12, ptr %b.alloc
    %t13 = load i64, ptr %c.alloc
    %t14 = sub i64 %t13, 2
    store i64 %t14, ptr %c.alloc
    br label %while.cond

while.end:
    %t15 = load i64, ptr %c.alloc
    ret i64 %t15
}
