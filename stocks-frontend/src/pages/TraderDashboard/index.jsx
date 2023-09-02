import { useState } from 'react';
import Sidebar from '../../components/Sidebar';
import Stocks from '../../components/Stocks';
import Transactions from '../../components/Transactions';
import Portfolios from '../../components/Portfolios';

function TraderDashboard({currentUser}){
    const [module, setModule] = useState(null);

    const handleModuleSelection = (moduleName) => {
        setModule(moduleName)
    }

    return(
        <section className="page">
            
            <Sidebar 
                currentUser={currentUser}
                module={module} 
                handleModuleSelection={handleModuleSelection}
            />
            {module === 'Stocks' && <Stocks currentUser={currentUser} />}
            {module === 'Portfolios' && <Portfolios currentUser={currentUser} />}
            {module === 'Transactions' && <Transactions currentUser={currentUser} />}  
        </section>
    )
}

export default TraderDashboard;