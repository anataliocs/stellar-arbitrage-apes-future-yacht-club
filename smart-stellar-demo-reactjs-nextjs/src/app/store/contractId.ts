import { create } from 'zustand';

interface State {
    contractId: string;
}

interface Actions {
    setContractId: (contractId: State['contractId']) => void;
}

export const useContractIdStore = create<State & Actions>((set) => ({
    contractId: '',
    setContractId: (contractId) => set(() => ({ contractId: contractId })),
}));


