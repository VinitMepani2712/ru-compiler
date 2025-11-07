define i64 @foo(i64 %a) {
entry:
    br label %while.cond

while.cond:
    %a.alloc.0 = phi i64 [ %a, %if.end ], [ %t2, %while.body ]
    %c.alloc.0 = phi i64 [ 0, %if.end ], [ %t1, %while.body ]
    %cmp = icmp ult i64 %a.alloc.0, 6
    br i1 %cmp, label %while.body, label %while.end

while.body:
    %t1 = add i64 %c.alloc.0, %a.alloc.0
    %t2 = add i64 %a.alloc.0, 1
    br label %while.cond

while.end:
    %cmp1 = icmp ugt i64 %c.alloc.0, 8
    br i1 %cmp1, label %if.then, label %if.else

if.then:
    %t3 = sub i64 %c.alloc.0, 2
    br label %if.end

if.else:
    br label %if.end

if.end:
    %c.alloc.1 = phi i64 [ %t3, %if.then ], [ %c.alloc.0, %if.else ]
    ret i64 %c.alloc.1
}
