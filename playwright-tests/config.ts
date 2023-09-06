import { existsSync } from 'fs';

const isInDocker = existsSync('/.dockerenv');

export const baseUrl = isInDocker ? "http://web:3000" : "http://localhost:3000";
