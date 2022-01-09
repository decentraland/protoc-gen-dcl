import { Printer } from "ts-protoc-gen/lib/Printer";
import { RPCDescriptor } from "ts-protoc-gen/lib/service/common";

export function printRpcDescriptor(service: RPCDescriptor, printer: Printer) {
  printer.printLn(`export type ${service.name} = {`)
  service.methods.forEach((method) => {
    let responseType = `Promise<${method.responseType}>`
    if (method.responseStream) {
      responseType = `AsyncGenerator<${method.responseType}>`
    }
    printer.printIndentedLn(`${method.nameAsPascalCase}(arg: ${method.requestType}): ${responseType};`)
  })
  printer.printLn(`}`)
  printer.printEmptyLn()
}