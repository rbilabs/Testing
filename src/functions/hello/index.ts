import { Callback, Context } from 'aws-lambda';
export function handler(event: any, context: Context, callback: Callback): void {
  callback(null, 'hello world!');
}
