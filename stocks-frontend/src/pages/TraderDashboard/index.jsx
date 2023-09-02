import { useState } from 'react';
import Sidebar from '../../components/Sidebar';
import Stocks from '../../components/Stocks';
import Transactions from '../../components/Transactions';
import Portfolios from '../../components/Portfolios';
import axios from 'axios';

function TraderDashboard({setCurrentUser, currentUser}){
    const [module, setModule] = useState(null);
    const [showWithdrawModal, setShowWithdrawModal] = useState(false);
    const [showDepositModal, setShowDepositModal] = useState(false);
    const [depositAmount, setDepositAmount] = useState(0);
    const [withdrawAmount, setWithdrawAmount] = useState(0);

    const handleDeposit = async (e) => {
        e.preventDefault();
        
        if(depositAmount < 0){
            alert("Please input a valid amount");
            return;
        }

        try {
            const token = currentUser.token;
            await axios.post( 'http://localhost:3000/traders/deposit',
                { 
                    amount: depositAmount 
                },
                {
                    headers: {
                        Authorization: `Bearer ${token}`,
                    },
                }
            );
            setCurrentUser({ ...currentUser, balance: currentUser.balance + depositAmount });
            alert('Deposit successful');
            setShowDepositModal(false);
            setDepositAmount(0); 
        } catch (error) {
            console.error('Error depositing funds', error.response.data.error);
        }
    };

    const handleWithdraw = async (e) => {
        e.preventDefault();

        if(withdrawAmount < 0){
            alert("Please input a valid amount");
            return;
        }

        try {
            const token = currentUser.token;
            await axios.post('http://localhost:3000/traders/withdraw',
                { 
                    amount: withdrawAmount 
                },
                {
                    headers: {
                        Authorization: `Bearer ${token}`,
                    },
                }
            );
            setCurrentUser({ ...currentUser, balance: currentUser.balance - withdrawAmount });
            alert('Withdrawal successful');
            setShowWithdrawModal(false);
            setWithdrawAmount(0); 
        } catch (error) {
            console.error('Error withdrawing funds', error);
        }
    };

    const handleModuleSelection = (moduleName) => {
        setModule(moduleName)
    }

    return(
        <section className="page">
            
            <Sidebar 
                currentUser={currentUser}
                module={module} 
                handleModuleSelection={handleModuleSelection}
                showWithdrawModal={showWithdrawModal}
                setShowWithdrawModal={setShowWithdrawModal}
                showDepositModal={showDepositModal}
                setShowDepositModal={setShowDepositModal}
                depositAmount={depositAmount}
                setDepositAmount={setDepositAmount}
                withdrawAmount={withdrawAmount}
                setWithdrawAmount={setWithdrawAmount}
                handleDeposit={handleDeposit}
                handleWithdraw={handleWithdraw}
            />
            {module === 'Stocks' && <Stocks currentUser={currentUser} setCurrentUser={setCurrentUser} />}
            {module === 'Portfolios' && <Portfolios currentUser={currentUser} setCurrentUser={setCurrentUser} />}
            {module === 'Transactions' && <Transactions currentUser={currentUser} />}  
        </section>
    )
}

export default TraderDashboard;