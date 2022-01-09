// package: 
// file: s1.proto

import * as s1_pb from "./s1_pb";
import { RpcClientPort } from "@dcl/rpc";
import * as codegen from "@dcl/rpc/dist/codegen";

export type BookService = {
  GetBook(arg: s1_pb.GetBookRequest): Promise<s1_pb.Book>;
  QueryBooks(arg: s1_pb.QueryBooksRequest): AsyncGenerator<s1_pb.Book>;
}

export function loadBookService(port: RpcClientPort): BookService {
  const portFuture = port.loadModule("BookService");
  return {
    "GetBook": codegen.clientProcedureUnary(portFuture, "GetBook", s1_pb.GetBookRequest, s1_pb.Book),
    "QueryBooks": codegen.clientProcedureStream(portFuture, "QueryBooks", s1_pb.QueryBooksRequest, s1_pb.Book),
  }
}

