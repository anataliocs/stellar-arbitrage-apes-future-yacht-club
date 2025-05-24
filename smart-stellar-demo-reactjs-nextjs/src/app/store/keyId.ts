import { create } from 'zustand';

interface State {
    keyId: string;
}

interface Actions {
    setKeyId: (keyId: State['keyId']) => void;
}

export const useKeyIdStore = create<State & Actions>((set) => ({
    keyId: '',
    setKeyId: (keyId) => set(() => ({ keyId: keyId })),
}));

