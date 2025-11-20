use std::env;
use std::fs::{self, File};
use std::io::{self, Write};
use std::path::Path;

// Token Definitions
#[derive(Debug, Clone, PartialEq, Eq, Hash)]
pub enum Token {
    Identifier(String),
    Number(String),
    Plus,
    Minus,
    Star,
    Assign,
    LParen,
    RParen,
    LBrace,
    RBrace,
    Semi,
    Comma,
    Args,
    Int,
    If,
    Then,
    Else,
    While,
    Return,
    True,
    False,
    Le,
    Lt,
    Ge,
    Gt,
    EqEq,
    Eof,
}

#[allow(dead_code)]
impl Token {
    fn to_parse_tree_string(&self) -> String {
        match self {
            Token::Identifier(ref s) => format!("IDENTIFIER({})", s),
            Token::Number(ref s) => format!("NUMBER({})", s),
            Token::Plus => "PLUS".to_string(),
            Token::Minus => "MINUS".to_string(),
            Token::Star => "STAR".to_string(),
            Token::Assign => "ASSIGN".to_string(),
            Token::LParen => "LPAREN".to_string(),
            Token::RParen => "RPAREN".to_string(),
            Token::LBrace => "LBRACE".to_string(),
            Token::RBrace => "RBRACE".to_string(),
            Token::Semi => "SEMI".to_string(),
            Token::Comma => "COMMA".to_string(),
            Token::Args => "ARGS".to_string(),
            Token::Int => "INT".to_string(),
            Token::If => "IF".to_string(),
            Token::Then => "THEN".to_string(),
            Token::Else => "ELSE".to_string(),
            Token::While => "WHILE".to_string(),
            Token::Return => "RETURN".to_string(),
            Token::True => "TRUE".to_string(),
            Token::False => "FALSE".to_string(),
            Token::Le => "LE".to_string(),
            Token::Lt => "LT".to_string(),
            Token::Ge => "GE".to_string(),
            Token::Gt => "GT".to_string(),
            Token::EqEq => "EQEQ".to_string(),
            Token::Eof => "EOF".to_string(),
        }
    }
}

// Scanner
struct Scanner {
    chars: Vec<char>,
    current: usize,
}

impl Scanner {
    fn new(input: &str) -> Self {
        Scanner {
            chars: input.chars().collect(),
            current: 0,
        }
    }

    fn peek(&self) -> Option<char> {
        self.chars.get(self.current).copied()
    }

    fn advance(&mut self) -> Option<char> {
        if self.current < self.chars.len() {
            let c = self.chars[self.current];
            self.current += 1;
            Some(c)
        } else {
            None
        }
    }

    fn skip_whitespace(&mut self) {
        while self.peek().map_or(false, |c| c.is_ascii_whitespace()) {
            self.advance();
        }
    }

    fn scan_token(&mut self) -> Option<Token> {
        self.skip_whitespace();
        let c = match self.advance() {
            Some(c) => c,
            None => return Some(Token::Eof),
        };

        let t = match c {
            '+' => Token::Plus,
            '-' => Token::Minus,
            '*' => Token::Star,
            '(' => Token::LParen,
            ')' => Token::RParen,
            '{' => Token::LBrace,
            '}' => Token::RBrace,
            ';' => Token::Semi,
            ',' => Token::Comma,

            '=' => {
                if self.peek() == Some('=') {
                    self.advance();
                    Token::EqEq
                } else {
                    Token::Assign
                }
            }

            '<' => {
                if self.peek() == Some('=') {
                    self.advance();
                    Token::Le
                } else {
                    Token::Lt
                }
            }

            '>' => {
                if self.peek() == Some('=') {
                    self.advance();
                    Token::Ge
                } else {
                    Token::Gt
                }
            }

            d if d.is_ascii_digit() => {
                let mut lexeme = d.to_string();
                while self.peek().map_or(false, |n| n.is_ascii_digit()) {
                    lexeme.push(self.advance().unwrap());
                }
                return Some(Token::Number(lexeme));
            }

            a if a.is_ascii_alphabetic() => {
                let mut lexeme = a.to_string();
                while self.peek().map_or(false, |n| n.is_ascii_alphanumeric()) {
                    lexeme.push(self.advance().unwrap());
                }
                return Some(match lexeme.as_str() {
                    "args" => Token::Args,
                    "int" => Token::Int,
                    "if" => Token::If,
                    "then" => Token::Then,
                    "else" => Token::Else,
                    "while" => Token::While,
                    "return" => Token::Return,
                    "true" => Token::True,
                    "false" => Token::False,
                    _ => Token::Identifier(lexeme),
                });
            }

            _ => {
                eprintln!("Error: Unexpected character '{}'.", c);
                return None;
            }
        };

        Some(t)
    }

    pub fn scan_all(&mut self) -> Vec<Token> {
        let mut tokens = Vec::new();
        loop {
            match self.scan_token() {
                Some(tok) => {
                    let eof = matches!(tok, Token::Eof);
                    tokens.push(tok);
                    if eof {
                        break;
                    }
                }
                None => break,
            }
        }
        tokens
    }
}

// AST Structures
#[derive(Debug, Clone)]
enum ExprNode {
    Number(i64),
    Identifier(String),
    BinOp(String, Box<ExprNode>, Box<ExprNode>),
}

#[derive(Debug, Clone)]
enum BoolExpr {
    True,
    False,
    Cmp(String, ExprNode, ExprNode),
}

#[derive(Debug, Clone)]
enum Stmt {
    Assign(String, ExprNode),
    IfThenElse(BoolExpr, Vec<Stmt>, Vec<Stmt>),
    While(BoolExpr, Vec<Stmt>),
    Return(String),
    Empty,
}

#[derive(Debug, Clone)]
struct Program {
    args: Vec<String>,
    vars: Vec<String>,
    stmts: Vec<Stmt>,
    ret: String,
}

// Parser
struct Parser {
    tokens: Vec<Token>,
    current: usize,
}

impl Parser {
    fn new(tokens: Vec<Token>) -> Self {
        Parser { tokens, current: 0 }
    }
    fn peek(&self) -> &Token {
        &self.tokens[self.current]
    }
    fn consume(&mut self) -> Token {
        let t = self.tokens[self.current].clone();
        self.current += 1;
        t
    }

    fn expect_token(&mut self, t: Token) {
        let next = self.consume();
        if next != t {
            panic!("Expected {:?}, found {:?}", t, next);
        }
    }

    fn expect_ident(&mut self) -> String {
        if let Token::Identifier(s) = self.consume() {
            s
        } else {
            panic!("Expected identifier")
        }
    }

    fn parse_program(&mut self) -> Program {
        self.expect_token(Token::Args);
        let args = self.parse_id_list();
        self.expect_token(Token::Semi);
        self.expect_token(Token::Int);
        let vars = self.parse_id_list();
        self.expect_token(Token::Semi);

        let mut stmts = Vec::new();
        while !matches!(self.peek(), Token::Return) {
            stmts.push(self.parse_stmt());
        }

        self.expect_token(Token::Return);
        let ret = self.expect_ident();
        self.expect_token(Token::Semi);

        Program {
            args,
            vars,
            stmts,
            ret,
        }
    }

    fn parse_id_list(&mut self) -> Vec<String> {
        let mut ids = Vec::new();
        ids.push(self.expect_ident());
        while matches!(self.peek(), Token::Comma) {
            self.consume();
            ids.push(self.expect_ident());
        }
        ids
    }

    fn parse_stmt(&mut self) -> Stmt {
        match self.peek() {
            Token::Identifier(_) => self.parse_assign(),
            Token::If => self.parse_if(),
            Token::While => self.parse_while(),
            Token::Return => {
                self.consume();
                let var = self.expect_ident();
                self.expect_token(Token::Semi);
                Stmt::Return(var)
            }
            Token::Semi => {
                self.consume();
                Stmt::Empty
            }
            _ => panic!("Unexpected token in statement: {:?}", self.peek()),
        }
    }

    fn parse_assign(&mut self) -> Stmt {
        let name = if let Token::Identifier(id) = self.consume() {
            id
        } else {
            unreachable!()
        };
        self.expect_token(Token::Assign);
        let expr = self.parse_expr();
        self.expect_token(Token::Semi);
        Stmt::Assign(name, expr)
    }

    fn parse_if(&mut self) -> Stmt {
        self.consume(); // if
        let cond = self.parse_bool();
        self.expect_token(Token::Then);
        self.expect_token(Token::LBrace);
        let mut then_stmts = Vec::new();
        while !matches!(self.peek(), Token::RBrace) {
            then_stmts.push(self.parse_stmt());
        }
        self.expect_token(Token::RBrace);
        self.expect_token(Token::Else);
        self.expect_token(Token::LBrace);
        let mut else_stmts = Vec::new();
        while !matches!(self.peek(), Token::RBrace) {
            else_stmts.push(self.parse_stmt());
        }
        self.expect_token(Token::RBrace);
        Stmt::IfThenElse(cond, then_stmts, else_stmts)
    }

    fn parse_while(&mut self) -> Stmt {
        self.consume(); // while
        let cond = self.parse_bool();
        self.expect_token(Token::Then);
        self.expect_token(Token::LBrace);
        let mut body = Vec::new();
        while !matches!(self.peek(), Token::RBrace) {
            body.push(self.parse_stmt());
        }
        self.expect_token(Token::RBrace);
        Stmt::While(cond, body)
    }

    fn parse_bool(&mut self) -> BoolExpr {
        match self.peek() {
            Token::True => {
                self.consume();
                BoolExpr::True
            }
            Token::False => {
                self.consume();
                BoolExpr::False
            }
            _ => {
                let left = self.parse_expr();
                let op = match self.consume() {
                    Token::Le => "<=".to_string(),
                    Token::Lt => "<".to_string(),
                    Token::Ge => ">=".to_string(),
                    Token::Gt => ">".to_string(),
                    Token::EqEq => "==".to_string(),
                    other => panic!("Unexpected token in comparison: {:?}", other),
                };
                let right = self.parse_expr();
                BoolExpr::Cmp(op, left, right)
            }
        }
    }

    fn parse_expr(&mut self) -> ExprNode {
        let mut node = self.parse_term();
        while matches!(self.peek(), Token::Plus | Token::Minus) {
            let op = match self.consume() {
                Token::Plus => "+".to_string(),
                Token::Minus => "-".to_string(),
                _ => unreachable!(),
            };
            let rhs = self.parse_term();
            node = ExprNode::BinOp(op, Box::new(node), Box::new(rhs));
        }
        node
    }

    fn parse_term(&mut self) -> ExprNode {
        let mut node = self.parse_factor();
        while matches!(self.peek(), Token::Star) {
            self.consume();
            let rhs = self.parse_factor();
            node = ExprNode::BinOp("*".to_string(), Box::new(node), Box::new(rhs));
        }
        node
    }

    fn parse_factor(&mut self) -> ExprNode {
        match self.consume() {
            Token::Number(n) => ExprNode::Number(n.parse::<i64>().unwrap()),
            Token::Identifier(id) => ExprNode::Identifier(id),
            Token::LParen => {
                let expr = self.parse_expr();
                self.expect_token(Token::RParen);
                expr
            }
            _ => panic!("Unexpected token in factor"),
        }
    }
}

fn generate_llvm_ir(prog: &Program) -> String {
    use std::collections::BTreeSet;

    struct Ids {
        t: i32,
        cmp: i32,
    }

    impl Ids {
        fn new() -> Self {
            Self { t: 0, cmp: 0 }
        }

        fn next_tmp(&mut self) -> String {
            self.t += 1;
            format!("%t{}", self.t)
        }

        fn next_cmp(&mut self) -> String {
            self.cmp += 1;
            if self.cmp == 1 {
                "%cmp".to_string()
            } else {
                format!("%cmp{}", self.cmp - 1)
            }
        }
    }

    fn collect_assigned(sts: &[Stmt]) -> BTreeSet<String> {
        let mut set = BTreeSet::new();
        for st in sts {
            match st {
                Stmt::Assign(v, _) => {
                    set.insert(v.clone());
                }
                Stmt::IfThenElse(_, a, b) => {
                    set.extend(collect_assigned(a));
                    set.extend(collect_assigned(b));
                }
                Stmt::While(_, body) => {
                    set.extend(collect_assigned(body));
                }
                _ => {}
            }
        }
        set
    }

    fn emit_expr(e: &ExprNode, ids: &mut Ids, out: &mut String) -> String {
        match e {
            ExprNode::Number(n) => n.to_string(),

            ExprNode::Identifier(x) => {
                let tmp = ids.next_tmp();
                out.push_str(&format!("    {} = load i64, ptr %{}.alloc\n", tmp, x));
                tmp
            }

            ExprNode::BinOp(op, l, r) => {
                let a = emit_expr(l, ids, out);
                let b = emit_expr(r, ids, out);

                let (name, inst) = match op.as_str() {
                    "+" => (ids.next_tmp(), "add"),
                    "-" => (ids.next_tmp(), "sub"),
                    "*" => (ids.next_tmp(), "mul"),
                    _ => unreachable!(),
                };

                out.push_str(&format!("    {} = {} i64 {}, {}\n", name, inst, a, b));
                name
            }
        }
    }

    fn emit_bool(b: &BoolExpr, ids: &mut Ids, out: &mut String) -> String {
        match b {
            BoolExpr::True => {
                let c = ids.next_cmp();
                out.push_str(&format!("    {} = icmp eq i64 1, 1\n", c));
                c
            }

            BoolExpr::False => {
                let c = ids.next_cmp();
                out.push_str(&format!("    {} = icmp eq i64 0, 1\n", c));
                c
            }

            BoolExpr::Cmp(op, l, r) => {
                let a = emit_expr(l, ids, out);
                let b = emit_expr(r, ids, out);
                let c = ids.next_cmp();

                let pred = match op.as_str() {
                    "<" => "ult",
                    ">" => "ugt",
                    "<=" => "ule",
                    ">=" => "uge",
                    "==" => "eq",
                    _ => "eq",
                };

                out.push_str(&format!("    {} = icmp {} i64 {}, {}\n", c, pred, a, b));
                c
            }
        }
    }


    fn emit_stmts(stmts: &[Stmt], ids: &mut Ids, out: &mut String) -> bool {
        let mut did_return = false;

        for st in stmts {
            if did_return {
                break;
            }

            match st {
                Stmt::Assign(v, e) => {
                    let val = emit_expr(e, ids, out);
                    out.push_str(&format!("    store i64 {}, ptr %{}.alloc\n", val, v));
                }

                Stmt::IfThenElse(cond, then_blk, else_blk) => {
                    let c = emit_bool(cond, ids, out);
                    out.push_str(&format!(
                        "    br i1 {}, label %if.then, label %if.else\n",
                        c
                    ));

                    out.push_str("\nif.then:\n");
                    let then_ret = emit_stmts(then_blk, ids, out);
                    if !then_ret {
                        out.push_str("    br label %if.end\n");
                    }

                    out.push_str("\nif.else:\n");
                    let else_ret = emit_stmts(else_blk, ids, out);
                    if !else_ret {
                        out.push_str("    br label %if.end\n");
                    }

                    out.push_str("\nif.end:\n");
                    if then_ret && else_ret {
                        return true;
                    }

                }

                Stmt::While(cond, body) => {
                    out.push_str("    br label %while.cond\n\n");

                    out.push_str("while.cond:\n");
                    let cnd = emit_bool(cond, ids, out);
                    out.push_str(&format!(
                        "    br i1 {}, label %while.body, label %while.end\n\n",
                        cnd
                    ));

                    out.push_str("while.body:\n");
                    let body_ret = emit_stmts(body, ids, out);

                    if body_ret {
                        out.push_str("\nwhile.end:\n");
                        return true;
                    } else {
                        out.push_str("    br label %while.cond\n\n");
                        out.push_str("while.end:\n");
                    }
                }


                Stmt::Return(v) => {
                    let tmp = ids.next_tmp();
                    out.push_str(&format!("    {} = load i64, ptr %{}.alloc\n", tmp, v));
                    out.push_str(&format!("    ret i64 {}\n", tmp));
                    did_return = true;
                }

                Stmt::Empty => {}
            }
        }

        did_return
    }

    let mut out = String::new();
    out.push_str(&format!("define i64 @foo("));
    out.push_str(
        &prog
            .args
            .iter()
            .map(|a| format!("i64 %{}", a))
            .collect::<Vec<_>>()
            .join(", "),
    );
    out.push_str(") {\nentry:\n");

    let mut vars: BTreeSet<String> = BTreeSet::new();
    for a in &prog.args {
        vars.insert(a.clone());
    }
    vars.extend(collect_assigned(&prog.stmts));

    for v in &vars {
        out.push_str(&format!("    %{}.alloc = alloca i64\n", v));
    }

    for a in &prog.args {
        out.push_str(&format!("    store i64 %{}, ptr %{}.alloc\n", a, a));
    }

    let mut ids = Ids::new();
    let did_return = emit_stmts(&prog.stmts, &mut ids, &mut out);

    if !did_return {
        let tmp = ids.next_tmp();
        out.push_str(&format!("    {} = load i64, ptr %{}.alloc\n", tmp, prog.ret));
        out.push_str(&format!("    ret i64 {}\n", tmp));
    }

    out.push_str("}\n");
    out  
}


fn main() -> io::Result<()> {
    let args: Vec<String> = env::args().collect();
    if args.len() != 2 {
        eprintln!("Usage: ./compiler <file>");
        std::process::exit(1);
    }

    let filename = &args[1];
    let contents = fs::read_to_string(filename)?;
    let mut scanner = Scanner::new(&contents);
    let tokens = scanner.scan_all();
    let mut parser = Parser::new(tokens);
    let prog = parser.parse_program();

    let llvm = generate_llvm_ir(&prog);

    let input_path = Path::new(filename);
    let out_dir = input_path
        .parent()
        .unwrap_or_else(|| Path::new("."))
        .join("outputLLVMIR");
    fs::create_dir_all(&out_dir)?;
    let stem = input_path
        .file_stem()
        .unwrap()
        .to_string_lossy()
        .to_string();
    let llvm_path = out_dir.join(format!("{}.ll", stem));
    let mut file = File::create(&llvm_path)?;
    file.write_all(llvm.as_bytes())?;
    println!("LLVM IR written to {}", llvm_path.display());
    Ok(())
}
