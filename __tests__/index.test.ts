import { handler } from '../index';

describe('Lambda function', () => {
    it('should not receive errors', async () => {
        const result = await handler();
        expect(result).toBe(undefined);
    })
})