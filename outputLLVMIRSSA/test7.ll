define i64 @foo(i64 %a) {
entry:
    %cmp = icmp ugt i64 %a, 2
    br i1 %cmp, label %if.then, label %if.else

if.then:
    %t1 = mul i64 %a, 2
    br label %if.end

if.else:
    %t2 = add i64 %a, 5
    br label %if.end

if.end:
    %b.alloc.0 = phi i64 [ %t1, %if.then ], [ %t2, %if.else ]
    br label %while.cond

while.cond:
    %b.alloc.1 = phi i64 [ %b.alloc.0, %if.end ], [ %t4, %while.body ]
    %c.alloc.0 = phi i64 [ 1, %if.end ], [ %t3, %while.body ]
    %cmp1 = icmp ugt i64 %b.alloc.1, 4
    br i1 %cmp1, label %while.body, label %while.end

while.body:
    %t3 = add i64 %c.alloc.0, %b.alloc.1
    %t4 = sub i64 %b.alloc.1, 1
    br label %while.cond

while.end:
    ret i64 %c.alloc.0
}
