import { createContext, useContext } from 'react';

const ApiContext = createContext();

export const ApiProvider = ({ children, apiUrl }) => {
    return (
        <ApiContext.Provider value={apiUrl}>
            {children}
        </ApiContext.Provider>
    );
};

export const useApiUrl = () => {
    return useContext(ApiContext);
};
