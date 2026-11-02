function download_MM(varargin)
% Download the files associated with the book Microdata for Matlab, by Abi Ada-
% ms, Damian Clarke, and Simon Quinn.  This program will download all .m files
% referred to in the book, and store them locally on your machine.  You can ei-
% ther specify the directory where you want the files saved as an argument, or
% specify no argument, and the files will be saved in the current directory.
% 
% Example:
%		download_MM
% which downloads all files and stores them in the current directory,
%
%		download_MM(DIR)
% which downloads the files and stores them in the directory DIR

	p = inputParser;
	addOptional(p, 'destination', pwd, @ischar)	

	p.parse(varargin{:});

  parseout = p.Results;

  if exist(parseout.destination,'dir') ~= 7
       error(['The folder: ''',parseout.destination, ''', does not exist.']);
  end

  %==============================================================================
  %=== (1) Directory Structure
  %==============================================================================
  Top = {'I_Foundations', 'II_DiscreteChoice', 'III_Dynamics', ...
         'IV_NonParametricMethods', 'V_Speed'}

  I_Foundations    = {'MatrixLaboratory', 'AgentOptimizes', 'EconomistOptimizes'}
  II_DiscreteChoice       = {'MultinomialChoice', 'DiscreteGames'}
  III_Dynamics            = {'FiniteHorizon', 'InfiniteHorizon'}
  IV_NonParametricMethods = {'NonParametricRegression','SemiparametricMethods'}
  V_Speed                 = {'Speed'}

  %==============================================================================
  %=== (2) All Programs
  %==============================================================================
  MatrixLaboratory        = {'auto.csv' 'OLS.m' 'Utility.m' 'UtilitySimple.m'   } 
  AgentOptimizes          = {'CobbDouglas.m' 'ConsumptionSim.m'                 }
  EconomistOptimizes      = {'auto.csv' 'NormalML.m' 'GMMObjective.m'           }
  MultinomialChoice       = {'BinaryLogitLL.m' 'BinaryLogitSimulatedLL.m'     ...
                             'GraphSimulatedData.m' 'Lambda.m MNLogitLL.m'    ...
                             'MNLogitSimulatedLL.m' 'MNProbitSimulatedLL.m'   ...
                             'MNProbitSimulatedLL_Smoothed.m'                 ...
                             'SimulateBinaryLogit.m' 'SimulateMNLogit.m'      ...
                             'SimulateMNProbit.m' 'SimulateMNProbit_Smoothed.m' }
  DiscreteGames           = {'BestResponse.m' 'bvnl.m' 'CournotLoss.m'        ...
                             'Demand.m' 'GraphBestResponse.m'                 ...
                             'GraphNashEquilibrium.m' 'mvnrnd.m' 'norm_cdf.m' ...
                             'Profit.m' 'SimulateBayesianNash.m'              ...
                             'SolveCournotNash.m' 'stdn_cdf.m'                ...
			     'BayesianNashLoss.m' 'SolveBayesianNash.m'       ...
			     'SolveBestResponse.m' 'BestResponseLoss.m'         }
  FiniteHorizon           = {'BackwardsInduc.m' 'DynamicMoments.m'            ...
                            'FiniteStochastic.m' 'FlowConstraint.m'           ...
                            'FlowUtility.m' 'SimulateStochastic.m'              }
  InfiniteHorizon         = {'ConvergeVF.m' 'GraphPolicy.m' 'IterateGraph.m'  ...
                             'IteratePolicy.m' 'IterateVF.m'                    }
  NonParametricRegression = {'Kreg.m' 'KregStruc.m' 'MSE.m'                     }
  SemiparametricMethods   = {'BiKreg.m' 'BiKregScript.m' 'Kreg.m' 'MSEg.m'    ... 
		             'PLMScript.m' 'SIMScript.m'                        }
  Speed                   = {'auto.csv' 'BootstrapOLS.m' 'GPUExample.m'       ...
 			     'MailResults.m' 'ParforBasics.m' 'SparseTests.m' ...
			     'TimeTests.m'}


  %==============================================================================
  %=== (3) Make directories, download
  %==============================================================================
  for s = 1:5
      mkdir(fullfile(parseout.destination,Top{s}));
      section = eval(Top{s});
      for c = 1:length(section)
          chapter = section{c};
          mkdir(fullfile(parseout.destination,Top{s},chapter));

          download(eval(chapter),Top{s},chapter)
      end
  end

  function download(filelist,sec,chap)
	for f = 1:length(filelist)
		file = filelist{f};

		Chap = strcat(sec,'/',chap)
		filesave = fullfile(parseout.destination,Chap,file);

		[fileconts, filestatus] = ...	
		urlread(['http://www.microeconometrics-code.com/code/',...
		sec,'/',chap,'/',file]);

		if ~filestatus
			fprintf('Unable to download %s.\n', file);
		else
			fid = fopen(filesave,'w');
			fwrite(fid,fileconts);
			fclose(fid);
			fprintf('Successfully downloaded: ''%s''.\n', filesave);
		end	
	end
  end
end
