import * as mod from "@std/text";
import * as fs from "@std/fs";

fs.walkSync("/");

console.log("Hi asd", mod.toKebabCase("alvin jay Deleverio"));
