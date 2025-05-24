import { writable, type Writable } from 'svelte/store';

export const keyId: Writable<string | null> = writable();