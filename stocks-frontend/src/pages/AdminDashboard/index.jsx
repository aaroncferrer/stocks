import { useState } from 'react';
import Sidebar from '../../components/Sidebar';
import Stocks from '../../components/Stocks';
import Transactions from '../../components/Transactions';
import './adminDashboard.css'
import Traders from '../../components/Traders';

function AdminDashboard({currentUser}){
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
            {module === 'Transactions' && <Transactions currentUser={currentUser} />}  
            {module === 'Traders' && <Traders currentUser={currentUser} />}  
        </section>
    )
}

export default AdminDashboard;