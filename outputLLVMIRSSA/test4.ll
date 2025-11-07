define i64 @foo(i64 %a) {
entry:
    %t1 = add i64 %a, 4
    %cmp = icmp ult i64 %t1, 8
    br i1 %cmp, label %if.then, label %if.else

if.then:
    %t2 = add i64 %t1, 2
    br label %if.end

if.else:
    %t3 = sub i64 %t1, 3
    br label %if.end

if.end:
    %b.alloc.0 = phi i64 [ %t2, %if.then ], [ %t3, %if.else ]
    br label %while.cond

while.cond:
    %b.alloc.1 = phi i64 [ %b.alloc.0, %if.end ], [ %t5, %while.body ]
    %c.alloc.0 = phi i64 [ 2, %if.end ], [ %t4, %while.body ]
    %cmp1 = icmp ugt i64 %b.alloc.1, 4
    br i1 %cmp1, label %while.body, label %while.end

while.body:
    %t4 = add i64 %c.alloc.0, %b.alloc.1
    %t5 = sub i64 %b.alloc.1, 2
    br label %while.cond

while.end:
    ret i64 %c.alloc.0
}
