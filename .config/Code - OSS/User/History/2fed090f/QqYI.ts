console.log("asdlvi");

Deno.serve(
    { hostname: "127.0.0.1", port: 9000 },
    (_req) => {
        return new Response("<h1>hi</h1>");
    },
);

export function add(num1: number, num2: number) {
    return num1 + num2;
}
