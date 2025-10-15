import { ModelSocket } from "modelsocket";

// connect to the mixlayer modelsocket server
// make sure you set MODELSOCKET_API_KEY in your env vars
const socket = await ModelSocket.connect("wss://models.mixlayer.ai/ws");

// open a llama 8b sequence
const seq = await socket.open("meta/llama3.1-8b-instruct-free");

// prompt for input
process.stderr.write("Enter your message (Ctrl+D to finish):\n");

// read input from stdin until EOF
let input = '';
for await (const chunk of process.stdin) {
  input += chunk;
}

// prompt the model with the input
seq.append(input, { role: "user" });

// produce a response
const stream = seq.gen({ role: "assistant" }).stream();

// print the response (use stdout.write to avoid new lines)
for await (const chunk of stream) {
  // if the chunk isn't hidden
  if (!chunk.hidden) {
    process.stdout.write(chunk.text);
  }
}

socket.close();
