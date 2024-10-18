console.log("asdlvi");

Deno.serve((_req) => {
    return new Response("hi");
});

export function add(num1: number, num2: number) {
    return num1 + num2;
}
